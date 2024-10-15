import Foundation
import UIKit
import CoreData

class RecentActivityListViewModel: NSObject,
                                   NSFetchedResultsControllerDelegate {
    let pageTitle: String = String.recentActivity.localized(
        "recentActivityNavigationTitle"
    )
    private let activityService: ActivityServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    private let urlOpener: URLOpener
    private let recentActivityHeaderFormatter = DateFormatter.recentActivityHeader
    private var retainedResultsController: NSFetchedResultsController<ActivityItem>?
    private var selectedEditingItems: Set<NSManagedObjectID> = []
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

    func edit(item: ActivityItem) {
        selectedEditingItems.insert(item.objectID)
    }

    func removeEdit(item: ActivityItem) {
        selectedEditingItems.remove(item.objectID)
    }

    func confirmDeletionOfEditingItems() {
        guard !selectedEditingItems.isEmpty else { return }
        activityService.delete(objectIds: Array(selectedEditingItems))
    }

    func endEditing() {
        selectedEditingItems.removeAll()
    }

    private func trackSelection(activity: ActivityItem) {
        let event = AppEvent.recentActivity(
            activity: activity
        )
        analyticsService.track(
            event: event
        )
    }

    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>,
                    didChangeContentWith
                    snapshot: NSDiffableDataSourceSnapshotReference) {
        let items = retainedResultsController?.fetchedObjects ?? []
        structure = sortActivites(activities: items)
    }
}
