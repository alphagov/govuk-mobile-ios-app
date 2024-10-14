import Foundation
import UIKit
import CoreData

class GroupedListViewModel: NSObject,
                            NSFetchedResultsControllerDelegate {
    let pageTitle: String = String.recentActivity.localized(
        "recentActivityNavigationTitle"
    )
    private let activityService: ActivityServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    private let urlOpener: URLOpener
    private let recentActivityHeaderFormatter = DateFormatter.recentActivityHeader
    private var retainedResultsController: NSFetchedResultsController<ActivityItem>?
    private(set) var structure: RecentActivitiesViewStructure = .init(
        todaysActivites: [],
        currentMonthActivities: [],
        recentMonthActivities: [:]
    )

    init(activityService: ActivityServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         urlopener: URLOpener) {
        self.activityService = activityService
        self.analyticsService = analyticsService
        self.urlOpener = urlopener
    }

    @discardableResult
    func fetchActivities() -> RecentActivitiesViewStructure {
        retainedResultsController = activityService.fetch()
        retainedResultsController?.delegate = self
        let items = retainedResultsController?.fetchedObjects ?? []
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

    func selected(item: ActivityItem) {
        guard let url = URL(string: item.url)
        else { return }
        item.date = Date()
        try? item.managedObjectContext?.save()
        urlOpener.openIfPossible(url)
        trackSelection(activity: item)
    }

    private func trackSelection(activity: ActivityItem) {
        let event = AppEvent.recentActivity(
            activity: activity.title
        )
        analyticsService.track(
            event: event
        )
    }

    func deleteAllItems() {
        activityService.deleteAll()
        analyticsService.track(
            event: .clearRecentActivity()
        )
    }

    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>,
                    didChangeContentWith
                    snapshot: NSDiffableDataSourceSnapshotReference) {
        let items = retainedResultsController?.fetchedObjects ?? []
        structure = sortActivites(activities: items)
    }
}
