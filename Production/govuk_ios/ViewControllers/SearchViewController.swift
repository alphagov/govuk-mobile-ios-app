import UIKit
import UIComponents
import GOVKit

private typealias DataSource = UITableViewDiffableDataSource<SearchSection, SearchItem>
private typealias Snapshot = NSDiffableDataSourceSnapshot<SearchSection, SearchItem>

// swiftlint:disable:next type_body_length
class SearchViewController: BaseViewController,
                            TrackableScreen {
    private let viewModel: SearchViewModel
    private let searchBar: UISearchBar

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
        tableView.contentInset.top = 16
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
                self.didInvokeSearch(using: .history)
            }
        )
        localController.view.translatesAutoresizingMaskIntoConstraints = false
        return localController
    }()

    var trackingName: String { "Search" }

    init(viewModel: SearchViewModel,
         searchBar: UISearchBar) {
        self.viewModel = viewModel
        self.searchBar = searchBar
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

        configureUI()
        configureConstraints()
        configureErrorConstraints()
    }

    private func configureUI() {
        view.backgroundColor = GOVUKColors.fills.surfaceModal

        view.addSubview(tableView)
        view.addSubview(errorScrollView)
        errorScrollView.addSubview(errorView)

        addController(searchSuggestionsViewController)
        addController(searchHistoryViewController)

        tableView.isHidden = !viewModel.historyIsEmpty
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            tableView.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor
            ),
            tableView.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor
            ),
            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),

            searchSuggestionsViewController.view.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            searchSuggestionsViewController.view.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor,
                constant: -16
            ),
            searchSuggestionsViewController.view.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor,
                constant: 16
            ),
            searchSuggestionsViewController.view.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),

            searchHistoryViewController.view.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            searchHistoryViewController.view.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor,
                constant: -16
            ),
            searchHistoryViewController.view.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor,
                constant: 16
            ),
            searchHistoryViewController.view.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }

    private func configureErrorConstraints() {
        NSLayoutConstraint.activate([
            errorScrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 24
            ),
            errorScrollView.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor
            ),
            errorScrollView.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor
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

    private func didInvokeSearch(using type: SearchInvocationType) {
        handleSearchInvocationFocusState()
        let searchText = searchBar.text
        viewModel.search(
            text: searchText,
            type: type,
            completion: { [weak self] in
                self?.reloadSnapshot()
                self?.updateErrorView(
                    searchText: searchText
                )
                self?.updateFocus()
            }
        )
        searchSuggestionsViewController.hide()
        searchHistoryViewController.hide()
    }

    private func handleSearchInvocationFocusState() {
        searchBar.resignFirstResponder()
        let cancelButton = (searchBar.value(forKey: "cancelButton") as? UIButton)
        cancelButton?.isEnabled = true
        tableViewHeader.becomeFirstResponder()
    }

    private lazy var searchSuggestionsViewController: SearchSuggestionsViewController =  {
        let localController = SearchSuggestionsViewController(
            viewModel: viewModel.searchSuggestionsViewModel,
            selectionAction: { searchText in
                self.searchBar.text = searchText
                self.didInvokeSearch(using: .autocomplete)
            }
        )
        localController.view.translatesAutoresizingMaskIntoConstraints = false
        localController.hide()
        return localController
    }()

    private func updateFocus() {
        let view = errorScrollView.isHidden ? tableViewHeader : errorScrollView
        accessibilityLayoutChanged(focusView: view)
    }

    private func updateErrorView(searchText: String?) {
        var errorModel: AppErrorViewModel?
        switch viewModel.error {
        case .networkUnavailable:
            errorModel = AppErrorViewModel.networkUnavailable {
                self.didInvokeSearch(using: .typed)
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.text = ""
        clearResults()
    }

    private func clearResults() {
        viewModel.clearResults()
        reloadSnapshot()
        searchHistoryViewController.reloadSnapshot()
        tableView.isHidden = true
        searchSuggestionsViewController.hide()
        searchHistoryViewController.show()
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
        let currentText = textField.text ?? ""
        let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)

        // return true if enter / return pressed
        guard string != "\n" else {
            return true
        }

        guard !replacementText.isEmpty, replacementText.count >= 3
        else {
            clearResults()
            return true
        }

        updateSuggestions(replacementText)

        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didInvokeSearch(using: .typed)
        return true
    }

    private func updateSuggestions(_ searchBarText: String) {
        let suggestionsViewModel = viewModel.searchSuggestionsViewModel
        suggestionsViewModel.searchBarText = searchBarText

        suggestionsViewModel.suggestions { [weak self] in
            guard let self else { return }

            searchHistoryViewController.hide()

            let suggestions = suggestionsViewModel.suggestions
            if viewModel.results?.isEmpty == false && !suggestions.isEmpty {
                viewModel.clearResults()
                reloadSnapshot()
            }
            searchSuggestionsViewController.view.isHidden = suggestions.isEmpty
            searchSuggestionsViewController.reloadSnapshot()
        }
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

enum SearchInvocationType: String {
    case autocomplete, history, typed
}
