import UIKit
import CoreData
import Foundation
import SwiftUI
import Factory

class RecentActivitiesViewModel: NSObject,
                                 ObservableObject,
                                 NSFetchedResultsControllerDelegate {
    private var activityService: ActivityServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    private var retainedReultsController: NSFetchedResultsController<ActivityItem>?

    private let lastVisitedFormatter = DateFormatter.recentActivityLastVisited
    private let recentActivityHeaderFormatter = DateFormatter.recentActivityHeader
    private let urlOpener: URLOpener
    @Published var activities: [ActivityItem] = []

    private(set) var structure: RecentActivitiesViewStructure = .init(
        todaysActivites: [],
        currentMonthActivities: [],
        recentMonthActivities: [:]
    )

    let currentMonthActivitiesListTitle = String.recentActivity.localized(
        "recentActivityCurrentMonthItems"
    )

    let todaysActivitieslistTitle = String.recentActivity.localized(
        "recentActivitiesTodaysListTitle"
    )

    let alertTitle = String.recentActivity.localized(
        "recentActivityClearAllAlertTitle"
    )
    let alertDescription = String.recentActivity.localized(
        "recentActivityClearAllAlertWarningDesc"
    )
    let alertPrimaryButtonTitle = String.recentActivity.localized(
        "recentActivityAlertWarningConfirmation"
    )
    let alertSecondaryButtonTitle = String.recentActivity.localized(
        "recentActivityAlertDismissText"
    )
    let toolbarButtonTitle = String.recentActivity.localized(
        "recentActivityToolBarTitle"
    )

    let navigationTitle = String.recentActivity.localized(
        "recentActivityNavigationTitle"
    )

    init(urlOpener: URLOpener,
         analyticsService: AnalyticsServiceInterface,
         activityService: ActivityServiceInterface) {
        self.urlOpener = urlOpener
        self.analyticsService = analyticsService
        self.activityService = activityService
        super.init()
    }

    @discardableResult
    func fetchActivities() -> RecentActivitiesViewStructure {
        retainedReultsController? = activityService.fetch()
        retainedReultsController?.delegate = self
        let items = retainedReultsController?.fetchedObjects ?? []
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

    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>,
                    didChangeContentWith
                    snapshot: NSDiffableDataSourceSnapshotReference) {
        let items = retainedReultsController?.fetchedObjects ?? []
        structure = sortActivites(activities: items)
    }

    @MainActor
    func deleteActivities() {
        activityService.deleteAll()
        analyticsService.track(
            event: .clearRecentActivity()
        )
    }

    private func selectActivity(item: ActivityItem) {
        item.date = Date()
        try? item.managedObjectContext?.save()
        guard let url = URL(string: item.url) else { return }
        urlOpener.openIfPossible(url)
        trackSelection(activity: item)
    }

    func returnActivityRow(activityItem: ActivityItem) -> LinkRow {
        LinkRow(
            id: activityItem.id,
            title: activityItem.title,
            body: lastVisitedString(activity: activityItem),
            action: {
                self.selectActivity(item: activityItem)
            }
        )
    }

    private func lastVisitedString(activity: ActivityItem) -> String {
        let copy = String.recentActivity.localized(
            "recentActivityFormattedDateStringComponent"
        )
        let formattedDateString = lastVisitedFormatter.string(from: activity.date)
        return "\(copy) \(formattedDateString)"
    }

    private func trackSelection(activity: ActivityItem) {
        let event = AppEvent.recentActivity(
            activity: activity.title
        )
        analyticsService.track(
            event: event
        )
    }

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }
}
