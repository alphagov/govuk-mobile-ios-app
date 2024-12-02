import UIKit
import UIComponents

private typealias DataSource = UITableViewDiffableDataSource<SearchSection, SearchItem>
private typealias Snapshot = NSDiffableDataSourceSnapshot<SearchSection, SearchItem>

class SearchViewController: BaseViewController,
                            TrackableScreen,
                            UITableViewDelegate {
    private let viewModel: SearchViewModel
    private let dismissAction: () -> Void

    private lazy var errorView: UIView = {
        self.appErrorViewController.view
    }()

    private lazy var appErrorViewController: HostingViewController = {
        let localController = HostingViewController(
            rootView: AppErrorView()
        )
        localController.view.translatesAutoresizingMaskIntoConstraints = false
        localController.view.backgroundColor = .govUK.fills.surfaceModal
        localController.view.isHidden = true
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


    private let tableView: UITableView = {
        let tableView = UITableView()
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

    var trackingName: String { "Search" }

    init(viewModel: SearchViewModel,
         dismissAction: @escaping () -> Void) {
        self.viewModel = viewModel
        self.dismissAction = dismissAction
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataSource
        tableView.delegate = self
        searchBar.searchTextField.delegate = self

        if #available(iOS 15.0, *) {
            sheetPresentationController?.prefersGrabberVisible = true
        }

        configureUI()
        configureConstraints()
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
        view.addSubview(errorView)
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

            errorView.topAnchor.constraint(
                equalTo: searchBar.bottomAnchor, constant: 24
            ),
            errorView.leftAnchor.constraint(
                equalTo: searchBar.leftAnchor,
                constant: 10
            ),
            errorView.rightAnchor.constraint(
                equalTo: searchBar.rightAnchor,
                constant: -10
            ),
            errorView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),

            tableView.topAnchor.constraint(
                equalTo: searchBar.bottomAnchor,
                constant: 16
            ),
            tableView.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor
            ),
            tableView.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor
            ),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
    }

    private func updateFocus() {
        let view = errorView.isHidden ? tableView : errorView
        accessibilityLayoutChanged(focusView: view)
    }

    private func updateErrorView(searchText: String?) {
        var errorModel: AppErrorViewModel?
        switch viewModel.error {
        case .networkUnavailable:
            errorModel = AppErrorViewModel.networkUnavailable {
                self.searchReturnPressed()
            }
            errorView.isHidden = false
        case .apiUnavailable, .parsingError:
            errorModel = AppErrorViewModel.genericError(
                urlOpener: viewModel.urlOpener
            )
            errorView.isHidden = false
        case .noResults:
            errorModel = AppErrorViewModel(
                body: "No results for ’\(searchText ?? "")’"
            )
            errorView.isHidden = false
        case .none:
            errorView.isHidden = true
        }
        appErrorViewController.rootView.viewModel = errorModel
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

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath)
        else { return }
        viewModel.selected(item: item)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.clearResults()
        reloadSnapshot()

        return true
    }
}

enum SearchSection {
    case results
}
