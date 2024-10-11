import Foundation
import UIKit

private typealias DataSource = UITableViewDiffableDataSource<GroupListSection, GroupListItem>
private typealias Snapshot = NSDiffableDataSourceSnapshot<GroupListSection, GroupListItem>

class GroupedListViewController: BaseViewController,
                                 UITableViewDelegate {
    private lazy var tableView: UITableView = UITableView.groupedList
    private let lastVisitedFormatter = DateFormatter.recentActivityLastVisited
    private lazy var barButtonItem = UIBarButtonItem.recentActivitEdit(
        target: self,
        action: #selector(barButtonPressed)
    )
    private lazy var dataSource: DataSource = {
        let localDataSource = DataSource(
            tableView: tableView,
            cellProvider: loadCell
        )
        localDataSource.defaultRowAnimation = .fade
        return localDataSource
    }()

    private lazy var noItemsView = {
        let localView = ListInformationView()
        localView.backgroundColor = .clear
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.isHidden = true
        localView.configure(
            title: String.recentActivity.localized("recentActivityErrorViewTitle"),
            description: String.recentActivity.localized("recentActivityErrorViewDescription")
        )
        return localView
    }()

    private let viewModel: GroupedListViewModel

    init(viewModel: GroupedListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @objc
    private func barButtonPressed() {
        let alert = UIAlertController.clearAllRecentItems(
            confirmAction: { [weak self] in
                self?.viewModel.deleteAllItems()
                self?.reloadSnapshot()
            }
        )
        present(alert, animated: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.pageTitle
        configureUI()
        configureConstraints()
        tableView.delegate = self
        tableView.dataSource = dataSource
        viewModel.fetchActivities()
        reloadSnapshot()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.setRightBarButton(barButtonItem, animated: animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureUI() {
        view.backgroundColor = UIColor.govUK.fills.surfaceBackground
        view.addSubview(tableView)
        view.addSubview(noItemsView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            tableView.rightAnchor.constraint(
                equalTo: view.layoutMarginsGuide.rightAnchor
            ),
            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),
            tableView.leftAnchor.constraint(
                equalTo: view.layoutMarginsGuide.leftAnchor
            ),

            noItemsView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 40
            ),
            noItemsView.rightAnchor.constraint(
                equalTo: view.layoutMarginsGuide.rightAnchor
            ),
            noItemsView.leftAnchor.constraint(
                equalTo: view.layoutMarginsGuide.leftAnchor
            )
        ])
    }

    private func reloadSnapshot() {
        var snapshot = Snapshot()
        snapshot.deleteAllItems()
        viewModel.structure.sections.forEach {
            snapshot.appendSections([$0])
            snapshot.appendItems($0.items, toSection: $0)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
        tableView.isHidden = viewModel.structure.isEmpty
        noItemsView.isHidden = !viewModel.structure.isEmpty
    }

    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let localLabel = GroupedListSectionHeaderView()
        localLabel.text = viewModel.structure.sections[section].title
        return localLabel
    }

    private var loadCell: (UITableView, IndexPath, GroupListItem) -> GroupedListTableViewCell {
        return { [weak self] tableView, indexPath, item in
            let cell: GroupedListTableViewCell = tableView.dequeue(indexPath: indexPath)
            if let section = self?.viewModel.structure.sections[indexPath.section] {
                cell.configure(
                    title: item.activity.title,
                    description: self?.lastVisitedString(activity: item.activity),
                    top: indexPath.row == 0,
                    bottom: item == section.items.last
                )
            }
            return cell
        }
    }

    private func lastVisitedString(activity: ActivityItem) -> String {
        let copy = String.recentActivity.localized(
            "recentActivityFormattedDateStringComponent"
        )
        let formattedDateString = lastVisitedFormatter.string(from: activity.date)
        return "\(copy) \(formattedDateString)"
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath)
        else { return }
        viewModel.selected(item: item.activity)
        reloadSnapshot()
    }
}

struct GroupListSection: Hashable {
    let title: String
    let items: [GroupListItem]
}

struct GroupListItem: Hashable {
    let activity: ActivityItem
}
