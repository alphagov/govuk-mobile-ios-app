import UIKit
import UIComponents
import GOVKit

private typealias DataSource =
    UITableViewDiffableDataSource<SearchHistorySection, SearchHistoryItem>
private typealias Snapshot = NSDiffableDataSourceSnapshot<SearchHistorySection, SearchHistoryItem>

final class SearchHistoryViewController: UIViewController {
    private let viewModel: SearchHistoryViewModel
    private let selectionAction: ((String) -> Void)

    private let tableView: UITableView = {
        let localView = UITableView(frame: .zero, style: .grouped)
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.register(SearchHistoryCell.self)
        localView.rowHeight = UITableView.automaticDimension
        localView.backgroundColor = UIColor.govUK.fills.surfaceModal
        localView.contentInsetAdjustmentBehavior = .never
        localView.separatorColor = UIColor.govUK.strokes.listDivider
        localView.contentInset.top = 16
        return localView
    }()

    private let headerLabel: UILabel = {
        let localLabel = UILabel()
        localLabel.font = UIFont.govUK.title3Semibold
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

    private lazy var deleteAction: UIAction = {
        .init(
            handler: { [unowned self] _ in
                let viewController = UIAlertController.destructiveAlert(
                    title: String.search.localized("clearHistoryAlertTitle"),
                    buttonTitle: String.search.localized("clearHistoryAlertButtonTitle"),
                    message: String.search.localized("clearHistoryAlertMessage"),
                    handler: self.clearAllHistory
                )
                self.present(viewController, animated: true)
            }
        )
    }()

    private lazy var deleteButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = .zero
        configuration.titleAlignment = .trailing
        configuration.baseForegroundColor = UIColor.govUK.text.link
        configuration.baseBackgroundColor = .clear
        let button = UIButton(configuration: configuration)
        button.setTitle(String.search.localized("clearHistoryButtonTitle"), for: .normal)
        button.titleLabel?.font = UIFont.govUK.body
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.addAction(deleteAction, for: .touchUpInside)
        button.accessibilityLabel = String.search.localized("clearHistoryButtonAccessibilityTitle")
        button.accessibilityTraits = .button
        return button
    }()

    private lazy var tableViewHeader: UIView = {
        let headerView = UIView()

        headerStackView.addArrangedSubview(headerLabel)
        headerStackView.addArrangedSubview(UIView())
        headerStackView.addArrangedSubview(deleteButton)
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
        headerView.accessibilityElements = [headerLabel, deleteButton]
        return headerView
    }()

    private lazy var dataSource: DataSource = {
        let localDataSource = DataSource(
            tableView: tableView,
            cellProvider: { [weak self] in
                self?.cellProviderAction(tableView: $0, indexPath: $1, item: $2)
            }
        )
        localDataSource.defaultRowAnimation = .fade
        return localDataSource
    }()

    private func cellProviderAction(tableView: UITableView,
                                    indexPath: IndexPath,
                                    item: SearchHistoryItem) -> UITableViewCell {
        let cell: SearchHistoryCell = tableView.dequeue(indexPath: indexPath)
        cell.searchText = item.searchText
        cell.deleteAction = { [weak self] in
            self?.viewModel.delete(item)
            self?.reloadSnapshot()
        }
        return cell
    }

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
        if !viewModel.searchHistoryItems.isEmpty {
            view.isHidden = false
        }
    }

    func hide() {
        view.isHidden = true
    }

    private func configureUI() {
        view.addSubview(tableView)
        view.isHidden = viewModel.searchHistoryItems.isEmpty
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private var clearAllHistory: () -> Void {
        return { [weak self] in
            self?.hide()
            self?.viewModel.clearSearchHistory()
            self?.reloadSnapshot()
        }
    }

    func announce() {
        let count = viewModel.searchHistoryItems.count
        guard count > 0 else { return }
        var string = String.search.localized("previousSearchesAvailableAnnouncement")
        if count > 1 {
            string = String.search.localized("previousSearchesAvailableAnnouncementPlural")
            string = "\(count) \(string)"
        }
        AccessibilityAnnouncerService().announce(string)
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
