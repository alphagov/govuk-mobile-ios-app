import UIKit
import UIComponents
import GOVKit

private typealias DataSource = UITableViewDiffableDataSource<SearchSection, SearchItem>
private typealias Snapshot = NSDiffableDataSourceSnapshot<SearchSection, SearchItem>

// swiftlint: disable:next type_body_length
class SearchViewController: BaseViewController,
                            TrackableScreen {
    private let viewModel: SearchViewModel
    private let dismissAction: () -> Void

    private lazy var errorView: UIView = {
        self.appErrorViewController.view
    }()

    private lazy var errorScrollView: UIScrollView = {
        let localView = UIScrollView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.showsVerticalScrollIndicator = false
        localView.contentInsetAdjustmentBehavior = .always
        localView.backgroundColor = .govUK.fills.surfaceModal
        return localView
    }()

    private lazy var appErrorViewController: HostingViewController = {
        let localController = HostingViewController(
            rootView: AppErrorView()
        )
        localController.view.translatesAutoresizingMaskIntoConstraints = false
        localController.view.backgroundColor = .govUK.fills.surfaceModal
        return localController
    }()

    private lazy var searchBar: UISearchBar = {
        let localSearchBar = UISearchBar()

        let placeholderText = String.search.localized("searchBarPlaceholder")
        localSearchBar.searchTextField.backgroundColor = UIColor.govUK.fills.surfaceSearchBox
        localSearchBar.enablesReturnKeyAutomatically = false
        localSearchBar.translatesAutoresizingMaskIntoConstraints = false
        localSearchBar.backgroundImage = UIImage()
        localSearchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.govUK.text.secondary,
                NSAttributedString.Key.font: UIFont.govUK.body
            ]
        )
        localSearchBar.searchTextField.leftView?.tintColor = UIColor.govUK.text.secondary
        localSearchBar.searchTextField.addTarget(
            self,
            action: #selector(searchReturnPressed),
            for: UIControl.Event.editingDidEndOnExit
        )

        return localSearchBar
    }()

    private let tableViewHeader: UIView = {
        let headerView = UIView()
        let label = UILabel()

        headerView.addSubview(label)

        label.font = UIFont.govUK.title3Semibold
        label.text = String.search.localized("searchResultsTitle")
        label.accessibilityTraits = .header
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: headerView.topAnchor),
            label.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 32),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0)
        ])
        return headerView
    }()

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchResultCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.govUK.fills.surfaceModal
        return tableView
    }()

    private lazy var dataSource: DataSource = {
        let localDataSource = DataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, item in
                let cell: SearchResultCell = tableView.dequeue(indexPath: indexPath)
                cell.configure(item: item)
                return cell
            }
        )
        localDataSource.defaultRowAnimation = .fade
        return localDataSource
    }()

    private lazy var searchHistoryViewController: SearchHistoryViewController = {
        let localController = SearchHistoryViewController(
            viewModel: viewModel.searchHistoryViewModel,
            selectionAction: { searchText in
                self.searchBar.text = searchText
                self.searchReturnPressed()
            }
        )
        localController.view.translatesAutoresizingMaskIntoConstraints = false
        return localController
    }()

    var trackingName: String { "Search" }

    init(viewModel: SearchViewModel,
         dismissAction: @escaping () -> Void) {
        self.viewModel = viewModel
        self.dismissAction = dismissAction
        super.init(analyticsService: viewModel.analyticsService)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataSource
        searchBar.searchTextField.delegate = self
        setupTableViewDelegate()

        sheetPresentationController?.prefersGrabberVisible = true

        configureUI()
        configureConstraints()
        configureErrorConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureNavBar(animated: animated)
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        searchBar.becomeFirstResponder()
    }

    private func configureUI() {
        title = String.search.localized("pageTitle")
        view.backgroundColor = GOVUKColors.fills.surfaceModal

        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(errorScrollView)
        errorScrollView.addSubview(errorView)

        addChild(self.searchHistoryViewController)
        view.addSubview(searchHistoryViewController.view)
        searchHistoryViewController.didMove(toParent: self)
        tableView.isHidden = !viewModel.historyIsEmpty
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: -10
            ),
            searchBar.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor,
                constant: -10
            ),
            searchBar.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor,
                constant: 10
            ),
            searchBar.heightAnchor.constraint(
                greaterThanOrEqualToConstant: 36
            ),

            tableView.topAnchor.constraint(
                equalTo: searchBar.bottomAnchor,
                constant: 6
            ),
            tableView.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor
            ),
            tableView.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor
            ),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            searchHistoryViewController.view.topAnchor.constraint(
                equalTo: searchBar.bottomAnchor,
                constant: 6
            ),
            searchHistoryViewController.view.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor,
                constant: -16
            ),
            searchHistoryViewController.view.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor,
                constant: 16
            ),
            searchHistoryViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureErrorConstraints() {
        NSLayoutConstraint.activate([
            errorScrollView.topAnchor.constraint(
                equalTo: searchBar.bottomAnchor, constant: 24
            ),
            errorScrollView.leftAnchor.constraint(
                equalTo: searchBar.leftAnchor
            ),
            errorScrollView.rightAnchor.constraint(
                equalTo: searchBar.rightAnchor
            ),
            errorScrollView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),

            errorView.topAnchor.constraint(
                equalTo: errorScrollView.topAnchor
            ),
            errorView.rightAnchor.constraint(
                equalTo: errorScrollView.rightAnchor
            ),
            errorView.leftAnchor.constraint(
                equalTo: errorScrollView.leftAnchor
            ),
            errorView.bottomAnchor.constraint(
                equalTo: errorScrollView.bottomAnchor
            ),
            errorView.widthAnchor.constraint(
                equalTo: errorScrollView.layoutMarginsGuide.widthAnchor
            )
        ])
    }

    private func configureNavBar(animated: Bool) {
        let barButton = UIBarButtonItem.cancel(
            target: self,
            action: #selector(cancelButtonPressed)
        )
        navigationItem.setLeftBarButton(
            barButton,
            animated: animated
        )
        navigationItem.standardAppearance = .govUK
        navigationItem.compactAppearance = .govUK
        navigationItem.scrollEdgeAppearance = .govUK
    }

    @objc
    private func cancelButtonPressed(_ sender: UIBarItem) {
        dismissAction()
    }

    @objc
    private func searchReturnPressed() {
        self.searchBar.resignFirstResponder()

        let searchText = searchBar.text
        viewModel.search(
            text: searchText,
            completion: { [weak self] in
                self?.reloadSnapshot()
                self?.updateErrorView(
                    searchText: searchText
                )
                self?.updateFocus()
            }
        )
        searchHistoryViewController.hide()
    }

    private func updateFocus() {
        let view = errorScrollView.isHidden ? tableViewHeader : errorScrollView
        accessibilityLayoutChanged(focusView: view)
    }

    private func updateErrorView(searchText: String?) {
        var errorModel: AppErrorViewModel?
        switch viewModel.error {
        case .networkUnavailable:
            errorModel = AppErrorViewModel.networkUnavailable {
                self.searchReturnPressed()
            }
            errorScrollView.isHidden = false
        case .apiUnavailable, .parsingError:
            errorModel = AppErrorViewModel.genericError(
                urlOpener: viewModel.urlOpener
            )
            errorScrollView.isHidden = false
        case .noResults:
            errorModel = AppErrorViewModel(
                body: "No results for ’\(searchText ?? "")’"
            )
            errorScrollView.isHidden = false
        case .none:
            errorScrollView.isHidden = true
        }
        appErrorViewController.rootView.viewModel = errorModel
        errorView.invalidateIntrinsicContentSize()
    }

    private func reloadSnapshot() {
        var snapshot = Snapshot()
        snapshot.deleteAllItems()
        if let results = viewModel.results {
            snapshot.appendSections([.results])
            snapshot.appendItems(results, toSection: .results)
        }
        dataSource.apply(snapshot, animatingDifferences: true)

        tableView.isHidden = viewModel.results?.isEmpty == true || viewModel.results == nil
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        errorView.invalidateIntrinsicContentSize()
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        clearResults()
        return true
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if string.isEmpty && textField.text?.count == 1 {
            clearResults()
        }
        return true
    }

    private func clearResults() {
        viewModel.clearResults()
        reloadSnapshot()
        searchHistoryViewController.reloadSnapshot()
        tableView.isHidden = true
        searchHistoryViewController.show()
    }
}

extension SearchViewController: UITableViewDelegate {
    func setupTableViewDelegate() {
        tableView.delegate = self
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath)
        else { return }
        viewModel.selected(item: item)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableViewHeader
    }
}

enum SearchSection {
    case results
}
