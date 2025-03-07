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
        let localHeaderView = UIView()
        let localLabel = UILabel()

        localHeaderView.addSubview(localLabel)

        localLabel.font = UIFont.govUK.title3Semibold
        localLabel.text = String.search.localized("searchSuggestionsTitle")
        localLabel.accessibilityTraits = .header
        localLabel.adjustsFontForContentSizeCategory = true
        localLabel.textAlignment = .left
        localLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            localLabel.topAnchor.constraint(equalTo: localHeaderView.topAnchor),
            localLabel.bottomAnchor.constraint(equalTo: localHeaderView.bottomAnchor,
                                               constant: -16),
            localLabel.leadingAnchor.constraint(equalTo: localHeaderView.leadingAnchor)
        ])

        return localHeaderView
    }()

    private let tableView: UITableView = {
        let localTableView = UITableView(frame: .zero, style: .grouped)

        localTableView.translatesAutoresizingMaskIntoConstraints = false
        localTableView.register(SuggestionCell.self)
        localTableView.separatorStyle = .singleLine
        localTableView.backgroundColor = UIColor.govUK.fills.surfaceModal
        localTableView.translatesAutoresizingMaskIntoConstraints = false
        localTableView.contentInsetAdjustmentBehavior = .never
        localTableView.separatorColor = UIColor.govUK.strokes.listDivider
        localTableView.contentInset.top = 16

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
        reloadSnapshot()
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

    func hide() {
        self.view.isHidden = true
    }

    func reloadSnapshot() {
        var snapshot = Snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.suggestions])
        snapshot.appendItems(viewModel.suggestions, toSection: .suggestions)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func configureUI() {
        view.addSubview(tableView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            ),
            tableView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
            tableView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            )
        ])
    }
}

extension SearchSuggestionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath)
        else { return }

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
