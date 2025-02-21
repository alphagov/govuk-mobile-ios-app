// swiftlint:disable file_length
import Foundation
import UIKit
import UIComponents
import GOVKit

private typealias DataSource = UITableViewDiffableDataSource<RecentActivitySection, ActivityItem>
private typealias Snapshot = NSDiffableDataSourceSnapshot<RecentActivitySection, ActivityItem>

// swiftlint:disable:next type_body_length
public final class RecentActivityListViewController: BaseViewController {
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

    private let titleBackgroundView: UIView = {
        let localView = UIView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.backgroundColor = .govUK.fills.surfaceHomeHeaderBackground
        return localView
    }()

    private let titleContainerView: UIView = {
        let localView = UIView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        return localView
    }()

    private lazy var titleLabel: UIView = {
        let localLabel = UILabel()
        localLabel.translatesAutoresizingMaskIntoConstraints = false
        localLabel.adjustsFontForContentSizeCategory = true
        localLabel.font = .govUK.largeTitleBold
        localLabel.numberOfLines = 0
        localLabel.textAlignment = .left
        localLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        localLabel.text = viewModel.pageTitle
        localLabel.accessibilityTraits = .header
        localLabel.textColor = .govUK.text.header
        return localLabel
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

    private lazy var informationScrollView: UIScrollView = {
        let localView = UIScrollView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.showsVerticalScrollIndicator = false
        localView.contentInsetAdjustmentBehavior = .always
        localView.isHidden = true
        return localView
    }()

    private lazy var informationView: UIView = {
        let localController = HostingViewController(
            rootView: AppErrorView()
        )
        localController.view.translatesAutoresizingMaskIntoConstraints = false
        localController.view.backgroundColor = .clear
        let localModel = AppErrorViewModel(
            title: String.recentActivity.localized("recentActivityNoPagesTitle"),
            body: String.recentActivity.localized("recentActivityNoPagesDescription")
        )
        localController.rootView.viewModel = localModel
        return localController.view
    }()

    public var trackingName: String { "Pages you've visited" }

    private let viewModel: RecentActivityListViewModel
    private var tabBarHeight: CGFloat {
        tabBarController?.tabBar.frame.height ?? 83.0
    }
    private var toolbarHeightConstraint: NSLayoutConstraint?
    private var isScrolled = false

    public init(viewModel: RecentActivityListViewModel) {
        self.viewModel = viewModel
        super.init(analyticsService: viewModel.analyticsService)
        navigationItem.largeTitleDisplayMode = .never
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureConstraints()
        tableView.delegate = self
        tableView.dataSource = dataSource
        viewModel.fetchActivities()
        reloadSnapshot()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let navBar = navigationController?.navigationBar
        UINavigationBar.setGovUKAppearance(navBar)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setEditing(false, animated: false)
    }

    private func configureUI() {
        view.backgroundColor = UIColor.govUK.fills.surfaceBackground
        titleContainerView.addSubview(titleLabel)
        titleBackgroundView.addSubview(titleContainerView)
        view.addSubview(titleBackgroundView)
        view.addSubview(tableView)
        view.addSubview(informationScrollView)
        view.addSubview(editingToolbar)
        informationScrollView.addSubview(informationView)
        removeBarButtonItem.isEnabled = false
        configureToolbarItems()
        setEditButtonAccessibilityLabel()
    }

    private func configureConstraints() {
        configureTitleConstraints()
        configureTableConstraints()
        configureToolbarConstraints()
    }

    private func configureTitleConstraints() {
        NSLayoutConstraint.activate([
            titleBackgroundView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            titleBackgroundView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            titleBackgroundView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),

            titleContainerView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            titleContainerView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            ),
            titleContainerView.topAnchor.constraint(
                equalTo: titleBackgroundView.topAnchor
            ),
            titleContainerView.bottomAnchor.constraint(
                equalTo: titleBackgroundView.bottomAnchor, constant: -8
            ),

            titleLabel.leadingAnchor.constraint(
                equalTo: titleContainerView.leadingAnchor
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: titleContainerView.trailingAnchor
            ),
            titleLabel.topAnchor.constraint(
                equalTo: titleContainerView.topAnchor
            ),
            titleLabel.bottomAnchor.constraint(
                equalTo: titleContainerView.bottomAnchor
            )
        ])
    }

    private func configureTableConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: titleBackgroundView.bottomAnchor,
                constant: 16
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
            informationScrollView.topAnchor.constraint(
                equalTo: titleBackgroundView.bottomAnchor,
                constant: 40
            ),
            informationScrollView.rightAnchor.constraint(
                equalTo: view.layoutMarginsGuide.rightAnchor
            ),
            informationScrollView.leftAnchor.constraint(
                equalTo: view.layoutMarginsGuide.leftAnchor
            ),
            informationScrollView.bottomAnchor.constraint(
                equalTo: view.layoutMarginsGuide.bottomAnchor
            ),
            informationView.topAnchor.constraint(
                equalTo: informationScrollView.topAnchor
            ),
            informationView.rightAnchor.constraint(
                equalTo: informationScrollView.rightAnchor
            ),
            informationView.leftAnchor.constraint(
                equalTo: informationScrollView.leftAnchor
            ),
            informationView.bottomAnchor.constraint(
                equalTo: informationScrollView.bottomAnchor
            ),
            informationView.widthAnchor.constraint(
                equalTo: informationScrollView.layoutMarginsGuide.widthAnchor
            )
        ])
    }

    private func configureToolbarConstraints() {
        toolbarHeightConstraint = editingToolbar.heightAnchor.constraint(
            equalToConstant: tabBarHeight)
        toolbarHeightConstraint?.isActive = true
        NSLayoutConstraint.activate([
            editingToolbar.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            editingToolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            editingToolbar.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            )
        ])
    }

    private func setEditButtonAccessibilityLabel() {
        editButtonItem.accessibilityLabel = String.recentActivity.localized(
            "editButtonAccessibilityTitle"
        )
    }

    override public func setEditing(_ editing: Bool, animated: Bool) {
        // Needs to be before super to get correct values
        trackEditingEvent()
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
        configureToolbarItems(animated: false)
        self.tabBarController?.tabBar.isHidden = editing
        editingToolbar.isHidden = !editing

        if !editing {
            editButtonItem.accessibilityLabel = String.recentActivity.localized(
                "editButtonAccessibilityTitle"
            )
            viewModel.endEditing()
        } else {
            editButtonItem.title = String.common.localized("cancel")
            editButtonItem.accessibilityLabel = String.recentActivity.localized(
                "doneButtonAccessibilityTitle"
            )
        }
    }

    override public func viewDidLayoutSubviews() {
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
        informationScrollView.isHidden = hasRecentActivity
        let rightNavBarButton = hasRecentActivity ? editButtonItem : nil
        navigationItem.setRightBarButton(rightNavBarButton, animated: true)
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

    private func configureToolbarItems(animated: Bool = true) {
        removeBarButtonItem.isEnabled = tableView.indexPathForSelectedRow?.isEmpty == false
        let items = [
            viewModel.isEveryItemSelected() ? deselectAllBarButtonItem : selectAllBarButtonItem,
            .flexibleSpace(),
            removeBarButtonItem
        ]
        editingToolbar.setItems(items, animated: animated)
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        toolbarHeightConstraint?.constant = tabBarHeight
        informationView.invalidateIntrinsicContentSize()
    }
}

extension RecentActivityListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let localLabel = GroupedListSectionHeaderView()
        localLabel.text = viewModel.structure.sections[section].title
        return localLabel
    }

    public func tableView(_ tableView: UITableView,
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

    public func tableView(_ tableView: UITableView,
                   didDeselectRowAt indexPath: IndexPath) {
        removeBarButtonItem.isEnabled = tableView.indexPathForSelectedRow?.isEmpty == false
        guard let item = dataSource.itemIdentifier(for: indexPath)
        else { return }
        viewModel.removeEdit(item: item)
        configureToolbarItems()
    }
}

extension RecentActivityListViewController: TrackableScreen {
    @MainActor
    public var trackingTitle: String? {
        viewModel.pageTitle
    }
}
// swiftlint:enable file_length
