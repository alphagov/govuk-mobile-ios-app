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
        localView.register(SearchHistoryCell.self)
        localView.rowHeight = UITableView.automaticDimension
        localView.backgroundColor = UIColor.govUK.fills.surfaceModal
        localView.contentInsetAdjustmentBehavior = .never
        return localView
    }()

    private let headerLabel: UILabel = {
        let localLabel = UILabel()
        localLabel.font = UIFont.govUK.bodySemibold
        localLabel.text = String.search.localized("searchHistoryTitle")
        localLabel.accessibilityTraits = .header
        localLabel.numberOfLines = 0
        localLabel.lineBreakMode = .byWordWrapping
        localLabel.adjustsFontForContentSizeCategory = true
        localLabel.textAlignment = .left
        localLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        localLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        return localLabel
    }()

    private let headerStackView: UIStackView = {
        let localStackView = UIStackView()
        localStackView.axis = .horizontal
        localStackView.spacing = 16
        localStackView.translatesAutoresizingMaskIntoConstraints = false
        localStackView.alignment = .firstBaseline
        localStackView.distribution = .fill
        return localStackView
    }()

    private lazy var tableViewHeader: UIView = {
        let headerView = UIView()

        let button: UIButton = .body(
            title: String.search.localized("clearHistoryButtonTitle"),
            accessibilityLabel: String.search.localized("clearHistoryButtonAccessibilityLabel")
        ) {
            self.present(UIAlertController.destructiveAlert(
                title: String.search.localized("clearHistoryAlertTitle"),
                buttonTitle: String.search.localized("clearHistoryAlertButtonTitle"),
                message: String.search.localized("clearHistoryAlertMessage"),
                handler: { [weak self] in
                self?.hide()
                self?.viewModel.clearSearchHistory()
                self?.reloadSnapshot()
            }), animated: true)
        }

        headerStackView.addArrangedSubview(headerLabel)
        headerStackView.addArrangedSubview(UIView())
        headerStackView.addArrangedSubview(button)
        headerView.addSubview(headerStackView)

        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(
                equalTo: headerView.topAnchor
            ),
            headerStackView.leadingAnchor.constraint(
                equalTo: headerView.leadingAnchor
            ),
            headerStackView.trailingAnchor.constraint(
                equalTo: headerView.trailingAnchor
            ),
            headerStackView.bottomAnchor.constraint(
                equalTo: headerView.bottomAnchor,
                constant: -16
            )
        ])
        return headerView
    }()

    private lazy var dataSource: DataSource = {
        let localDataSource = DataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, item in
                let cell: SearchHistoryCell = tableView.dequeue(indexPath: indexPath)
                cell.searchText = item.searchText
                cell.deleteAction = { [weak self] in
                    self?.viewModel.delete(item)
                    self?.reloadSnapshot()
                }
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
        if viewModel.searchHistoryItems.isEmpty {
            hide()
        }
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
