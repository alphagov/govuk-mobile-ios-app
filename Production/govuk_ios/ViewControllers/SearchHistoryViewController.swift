import UIKit
import UIComponents

private typealias DataSource =
    UITableViewDiffableDataSource<SearchHistorySection, SearchHistoryItem>
private typealias Snapshot = NSDiffableDataSourceSnapshot<SearchHistorySection, SearchHistoryItem>

final class SearchHistoryViewController: BaseViewController {
    private let viewModel: SearchHistoryViewModel
    private let selectionAction: ((String) -> Void)

    private let tableView: UITableView = {
        let localView = UITableView(frame: .zero, style: .grouped)
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.register(UITableViewCell.self)
        localView.rowHeight = UITableView.automaticDimension
        localView.backgroundColor = UIColor.govUK.fills.surfaceModal
        return localView
    }()

    private lazy var tableViewHeader: UIView = {
        let headerView = UIView()

        let label = UILabel()
        label.font = UIFont.govUK.bodySemibold
        label.text = String.search.localized("searchHistoryTitle")
        label.accessibilityTraits = .header
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)

        let button: UIButton = .body(
            title: String.search.localized("clearHistoryButtonTitle"),
            accessibilityLabel: String.search.localized("clearHistoryButtonAccessibilityLabel")
        ) {
            self.present(UIAlertController.destructiveAlert(
                title: String.search.localized("clearHistoryAlertTitle"),
                buttonTitle: String.search.localized("clearHistoryAlertButtonTitle"),
                message: String.search.localized("clearHistoryAlertMessage"),
                handler: {
                self.hide()
                self.viewModel.clearSearchHistory()
                self.reloadSnapshot()
            }), animated: true)
        }

        let stackView: UIStackView = .init(arrangedSubviews: [label, UIView(), button])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .firstBaseline
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: headerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        return headerView
    }()

    private lazy var dataSource: DataSource = {
        let localDataSource = DataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, item in
                let cell: UITableViewCell = tableView.dequeue(indexPath: indexPath)
                var configuration = cell.defaultContentConfiguration()
                configuration.text = item.searchText
                configuration.axesPreservingSuperviewLayoutMargins = .vertical
                cell.contentConfiguration = configuration
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .none
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

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableViewHeader
    }
}

enum SearchHistorySection {
    case history
}
