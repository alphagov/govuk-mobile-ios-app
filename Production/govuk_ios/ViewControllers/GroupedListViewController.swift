import Foundation
import UIKit

private typealias DataSource = UITableViewDiffableDataSource<GroupListSection, GroupListItem>
private typealias Snapshot = NSDiffableDataSourceSnapshot<GroupListSection, GroupListItem>

class GroupedListViewController: UIViewController,
                                 UITableViewDelegate {
    private lazy var tableView: UITableView = UITableView.groupedList
    private let lastVisitedFormatter = DateFormatter.recentActivityLastVisited
    private lazy var dataSource: DataSource = {
        let localDataSource = DataSource(
            tableView: tableView,
            cellProvider: loadCell
        )
        localDataSource.defaultRowAnimation = .fade
        return localDataSource
    }()

    private let viewModel: GroupedListViewModel

    init(viewModel: GroupedListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureConstraints()
        tableView.delegate = self
        tableView.dataSource = dataSource
        viewModel.fetchActivities()
        reloadSnapshot()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureUI() {
        view.backgroundColor = UIColor.govUK.fills.surfaceBackground
        view.addSubview(tableView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.topAnchor
            ),
            tableView.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor,
                constant: -10
            ),
            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),
            tableView.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor,
                constant: 10
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

//    private var selected: (ActivityItem) -> Void {
//        return { item in
//
//        }
//    }
}

struct GroupListSection: Hashable {
    let title: String
    let items: [GroupListItem]
}

struct GroupListItem: Hashable {
    let activity: ActivityItem
}
