import UIKit
import UIComponents

private typealias DataSource =
    UITableViewDiffableDataSource<SearchHistorySection, SearchHistoryItem>
private typealias Snapshot = NSDiffableDataSourceSnapshot<SearchHistorySection, SearchHistoryItem>

final class SearchHistoryViewController: BaseViewController {
    private let viewModel: SearchHistoryViewModel
    private let selectionAction: ((String) -> Void)
    private let tableView: UITableView = {
        let localView = UITableView(frame: .zero)
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.register(UITableViewCell.self)
        localView.backgroundColor = UIColor.govUK.fills.surfaceModal
        return localView
    }()

    private lazy var dataSource: DataSource = {
        let localDataSource = DataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, item in
                let cell: UITableViewCell = tableView.dequeue(indexPath: indexPath)
                var configuration = cell.defaultContentConfiguration()
                configuration.text = item.searchText
                cell.contentConfiguration = configuration
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        )
        localDataSource.defaultRowAnimation = .fade
        return localDataSource
    }()

    init(viewModel: SearchHistoryViewModel,
         selectionAction: @escaping ((String) -> Void)) {
        self.viewModel = viewModel
        self.selectionAction = selectionAction
        super.init(nibName: nil, bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        configureUI()
        configureConstraints()
        reloadSnapshot()
    }

    func reloadSnapshot() {
        var snapshot = Snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.history])
        snapshot.appendItems(viewModel.searchHistoryItems, toSection: .history)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func show() {
        self.view.isHidden = false
    }

    func hide() {
        self.view.isHidden = true
    }

    private func configureUI() {
        view.addSubview(tableView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension SearchHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        selectionAction(viewModel.searchHistoryItems[indexPath.row].searchText)
    }
}

enum SearchHistorySection {
    case history
}
