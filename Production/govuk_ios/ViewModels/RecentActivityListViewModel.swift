import Foundation
import UIKit
import CoreData
import GOVKit

final class RecentActivityListViewModel: NSObject,
                                   NSFetchedResultsControllerDelegate {
    let pageTitle: String = String.recentActivity.localized(
        "recentActivityNavigationTitle"
    )
    private let activityService: ActivityServiceInterface
    let analyticsService: AnalyticsServiceInterface
    private let recentActivityHeaderFormatter = DateFormatter.recentActivityHeader
    private var retainedResultsController: NSFetchedResultsController<ActivityItem>?
    private var selectedEditingItems: Set<NSManagedObjectID> = []
    private(set) var structure: RecentActivitiesViewStructure = .init(
        todaysActivites: [],
        currentMonthActivities: [],
        recentMonthActivities: [:]
    )
    private let selectedAction: (URL) -> Void

    init(activityService: ActivityServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         selectedAction: @escaping (URL) -> Void) {
        self.activityService = activityService
        self.analyticsService = analyticsService
        self.selectedAction = selectedAction
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
        var todaysActivities: [NSManagedObjectID] = []
        var currentMonthActivities: [NSManagedObjectID] = []
        var recentMonthsActivities: [MonthGroupKey: [NSManagedObjectID]] = [:]
        for recentActivity in activities {
            if recentActivity.date.isToday() {
                todaysActivities.append(recentActivity.objectID)
            } else if recentActivity.date.isThisMonth() {
                currentMonthActivities.append(recentActivity.objectID)
            } else {
                let key = MonthGroupKey(
                    date: recentActivity.date,
                    formatter: recentActivityHeaderFormatter
                )
                var items = recentMonthsActivities[key] ?? []
                items.append(recentActivity.objectID)
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
        selectedAction(url)
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

    func isEveryItemSelected() -> Bool {
        let items = retainedResultsController?.fetchedObjects ?? []
        guard items.count > 0 else { return false }
        return items.count == selectedEditingItems.count
    }

    private func trackSelection(activity: ActivityItem) {
        let event = AppEvent.recentActivityNavigation(
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

    func activityItem(for objectId: NSManagedObjectID) -> ActivityItem? {
        activityService.activityItem(for: objectId)
    }
}
