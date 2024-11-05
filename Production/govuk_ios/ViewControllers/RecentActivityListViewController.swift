import Foundation
import UIKit

private typealias DataSource = UITableViewDiffableDataSource<RecentActivitySection, ActivityItem>
private typealias Snapshot = NSDiffableDataSourceSnapshot<RecentActivitySection, ActivityItem>

class RecentActivityListViewController: BaseViewController,
                                        TrackableScreen,
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

    private lazy var removeBarButtonItem: UIBarButtonItem = .remove(
        action: { [unowned self] action in
            self.removeButtonPressed()
            self.trackActionPress(title: action.title, action: "Remove")
        }
    )

    private lazy var selectAllBarButtonItem: UIBarButtonItem = .selectAll(
        action: { [unowned self] action in
            self.selectAllButtonPressed()
            self.trackActionPress(title: action.title, action: "Select all")
        }
    )

    private lazy var deselectAllBarButtonItem: UIBarButtonItem = .deselectAll(
        action: { [unowned self] action in
            self.deselectAllButtonPressed()
            self.trackActionPress(title: action.title, action: "Deselect all")
        }
    )

    private lazy var editingToolbar: UIToolbar = {
        let localToolbar = UIToolbar(
            // This is to prevent a constraint error when loading
            frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
        )
        localToolbar.translatesAutoresizingMaskIntoConstraints = false
        localToolbar.insetsLayoutMarginsFromSafeArea = true
        localToolbar.isHidden = true
        return localToolbar
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

    var trackingName: String { "Pages you've visited" }

    private let viewModel: RecentActivityListViewModel
    private var tabBarHeight: CGFloat {
        tabBarController?.tabBar.frame.height ?? 83.0
    }
    private var toolbarHeightConstraint: NSLayoutConstraint?

    init(viewModel: RecentActivityListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = viewModel.pageTitle
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setEditing(false, animated: false)
    }

    private func configureUI() {
        view.backgroundColor = UIColor.govUK.fills.surfaceBackground
        view.addSubview(tableView)
        view.addSubview(noItemsView)
        view.addSubview(editingToolbar)
        removeBarButtonItem.isEnabled = false
        configureToolbarItems()
    }

    private func configureConstraints() {
        toolbarHeightConstraint = editingToolbar.heightAnchor.constraint(
            equalToConstant: tabBarHeight)
        toolbarHeightConstraint?.isActive = true
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
            ),
            editingToolbar.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            editingToolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            editingToolbar.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            )
        ])
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        // Needs to be before super to get correct values
        trackEditingEvent()
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
        configureToolbarItems(animated: false)
        self.tabBarController?.tabBar.isHidden = editing
        editingToolbar.isHidden = !editing
        if !editing {
            viewModel.endEditing()
        }
        reloadSnapshot()
    }

    override func viewDidLayoutSubviews() {
        guard let items = editingToolbar.items else { return }
        for item in items {
            guard let item = item as? TopAlignedBarButtonItem else { continue }
            item.updateLayout()
        }
    }

    private func trackEditingEvent() {
        trackActionPress(
            title: editButtonItem.title,
            action: isEditing ? "Done" : "Edit"
        )
    }

    @objc
    private func selectAllButtonPressed() {
        tableView.selectAllRows(animated: true)
    }

    @objc
    private func deselectAllButtonPressed() {
        tableView.deselectAllRows(animated: true)
    }

    @objc
    private func removeButtonPressed() {
        viewModel.confirmDeletionOfEditingItems()
        reloadSnapshot()
        setEditing(false, animated: true)
    }

    private func trackActionPress(title: String?,
                                  action: String) {
        guard let localTitle = title,
              !localTitle.isEmpty
        else { return }
        let event = AppEvent.recentActivityButtonFunction(
            title: localTitle,
            action: action
        )
        analyticsService.track(event: event)
    }

    private func reloadSnapshot() {
        var snapshot = Snapshot()
        snapshot.deleteAllItems()
        viewModel.structure.sections.forEach {
            snapshot.appendSections([$0])
            snapshot.appendItems($0.items, toSection: $0)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
        let hasRecentActivity = !viewModel.structure.isEmpty
        tableView.isHidden = !hasRecentActivity
        noItemsView.isHidden = hasRecentActivity
        let rightNavBarButton = hasRecentActivity ? editButtonItem : nil
        navigationItem.setRightBarButton(rightNavBarButton, animated: true)
    }

    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let localLabel = GroupedListSectionHeaderView()
        localLabel.text = viewModel.structure.sections[section].title
        return localLabel
    }

    private var loadCell: (UITableView, IndexPath, ActivityItem) -> GroupedListTableViewCell {
        return { [weak self] tableView, indexPath, item in
            let cell: GroupedListTableViewCell = tableView.dequeue(indexPath: indexPath)
            if let section = self?.viewModel.structure.sections[indexPath.section] {
                cell.configure(
                    title: item.title,
                    description: self?.lastVisitedString(activity: item),
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
        removeBarButtonItem.isEnabled = tableView.indexPathForSelectedRow?.isEmpty == false
        guard let item = dataSource.itemIdentifier(for: indexPath)
        else { return }
        if tableView.isEditing {
            viewModel.edit(item: item)
        } else {
            viewModel.selected(item: item)
            reloadSnapshot()
        }
        configureToolbarItems()
    }

    func tableView(_ tableView: UITableView,
                   didDeselectRowAt indexPath: IndexPath) {
        removeBarButtonItem.isEnabled = tableView.indexPathForSelectedRow?.isEmpty == false
        guard let item = dataSource.itemIdentifier(for: indexPath)
        else { return }
        viewModel.removeEdit(item: item)
        configureToolbarItems()
    }

    private func configureToolbarItems(animated: Bool = true) {
        removeBarButtonItem.isEnabled = tableView.indexPathForSelectedRow?.isEmpty == false
        let items = [
            viewModel.isEveryItemSelected() ? deselectAllBarButtonItem : selectAllBarButtonItem,
            .flexibleSpace(),
            removeBarButtonItem
        ]
        editingToolbar.setItems(items, animated: animated)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        toolbarHeightConstraint?.constant = tabBarHeight
    }
}

struct RecentActivitySection: Hashable {
    let title: String
    let items: [ActivityItem]
}
