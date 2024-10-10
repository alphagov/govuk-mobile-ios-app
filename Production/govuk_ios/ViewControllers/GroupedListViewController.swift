import Foundation
import UIKit

private typealias DataSource = UITableViewDiffableDataSource<ActivitySection, ActivityItem>
private typealias Snapshot = NSDiffableDataSourceSnapshot<ActivitySection, ActivityItem>

class GroupedListViewModel {
    private let activityService: ActivityServiceInterface
    private let recentActivityHeaderFormatter = DateFormatter.recentActivityHeader
    private(set) var structure: RecentActivitiesViewStructure = .init(
        todaysActivites: [],
        currentMonthActivities: [],
        recentMonthActivities: [:]
    )

    init(activityService: ActivityServiceInterface) {
        self.activityService = activityService
    }

    @discardableResult
    func fetchActivities() -> RecentActivitiesViewStructure {
        let items = activityService.fetch().fetchedObjects ?? []
        let localStructure = sortActivites(activities: items)
        structure = localStructure
        return localStructure
    }

    private func sortActivites(activities: [ActivityItem]) -> RecentActivitiesViewStructure {
        var todaysActivities: [ActivityItem] = []
        var currentMonthActivities: [ActivityItem] = []
        var recentMonthsActivities: [MonthGroupKey: [ActivityItem]] = [:]
        for recentActivity in activities {
            if recentActivity.date.isToday() {
                todaysActivities.append(recentActivity)
            } else if recentActivity.date.isThisMonth() {
                currentMonthActivities.append(recentActivity)
            } else {
                let key = MonthGroupKey(
                    date: recentActivity.date,
                    formatter: recentActivityHeaderFormatter
                )
                var items = recentMonthsActivities[key] ?? []
                items.append(recentActivity)
                recentMonthsActivities[key] = items
            }
        }

        return .init(
            todaysActivites: todaysActivities,
            currentMonthActivities: currentMonthActivities,
            recentMonthActivities: recentMonthsActivities
        )
    }
}

class GroupedListViewController: UIViewController,
                                 UITableViewDelegate {
    private lazy var tableView: UITableView = UITableView.groupedList
    private lazy var dataSource: DataSource = {
        let localDataSource = DataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, item in
                let cell: GroupedListTableViewCell = tableView.dequeue(indexPath: indexPath)
                let section = self.viewModel.structure.sections[indexPath.section]
                cell.configure(
                    title: item.title,
                    description: item.body,
                    top: indexPath.row == 0,
                    bottom: item == section.items.last
                )
                return cell
            }
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

//    func tableView(_ tableView: UITableView,
//                   heightForHeaderInSection
//                   section: Int) -> CGFloat {
//        24
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        <#code#>
//    }
}

struct ActivitySection: Hashable {
    let title: String
    let items: [ActivityItem]
}

extension UITableView {
    static var groupedList: UITableView {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GroupedListTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.estimatedSectionHeaderHeight = 24
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }
}
