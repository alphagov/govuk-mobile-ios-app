import Foundation
import UIKit
import GOVKit

private typealias DataSource = UITableViewDiffableDataSource<SearchSuggestionsSection,
                                                             SearchSuggestion>
private typealias Snapshot = NSDiffableDataSourceSnapshot<SearchSuggestionsSection,
                                                          SearchSuggestion>

class SearchSuggestionsViewController: BaseViewController {
    private let viewModel: SearchSuggestionsViewModel
    private let selectionAction: (String) -> Void

    private let tableViewHeader: UIView = {
        let headerView = UIView()
        let label = UILabel()

        headerView.addSubview(label)

        label.font = UIFont.govUK.title3Semibold
        label.text = String.search.localized("searchSuggestionsTitle")
        label.accessibilityTraits = .header
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: headerView.topAnchor),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16)
        ])

        return headerView
    }()

    private let tableView: UITableView = {
        let localTableView = UITableView()

        localTableView.translatesAutoresizingMaskIntoConstraints = false
        localTableView.register(SuggestionCell.self)
        localTableView.separatorStyle = .singleLine
        localTableView.backgroundColor = UIColor.govUK.fills.surfaceModal
        localTableView.translatesAutoresizingMaskIntoConstraints = false

        return localTableView
    }()

    public init(viewModel: SearchSuggestionsViewModel,
                selectionAction: @escaping (String) -> Void) {
        self.viewModel = viewModel
        self.selectionAction = selectionAction
        super.init(analyticsService: viewModel.analyticsService)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = dataSource

        configureUI()
        configureConstraints()
    }

    private lazy var dataSource: DataSource = {
        let localDataSource = DataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, item in
                let cell: SuggestionCell = tableView.dequeue(indexPath: indexPath)
                let highlightedSuggestion = self.viewModel.highlightSuggestion(
                    suggestion: item.text
                )
                cell.configure(suggestion: highlightedSuggestion)
                return cell
            }
        )
        localDataSource.defaultRowAnimation = .fade

        return localDataSource
    }()

    func reloadSnapshot() {
        var snapshot = Snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.suggestions])
        snapshot.appendItems(viewModel.suggestions, toSection: .suggestions)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func configureUI() {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            tableView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
            tableView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: -4
            )
        ])
    }
}

extension SearchSuggestionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath)
        else { return }

        tableView.isHidden = true
        viewModel.clearSuggestions()
        selectionAction(item.text)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableViewHeader
    }
}

enum SearchSuggestionsSection {
    case suggestions
}
