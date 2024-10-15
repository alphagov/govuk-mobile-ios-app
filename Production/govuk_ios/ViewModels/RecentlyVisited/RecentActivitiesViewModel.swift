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
    @Published var model: RecentActivitiesViewStructure = .init(
        todaysActivites: [],
        currentMonthActivities: [],
        recentMonthActivities: [:]
    )

    private let lastVisitedFormatter = DateFormatter.recentActivityLastVisited
    private let recentActivityHeaderFormatter = DateFormatter.recentActivityHeader
    private let urlOpener: URLOpener
    @Published var activities: [ActivityItem] = []

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
        setupFetchResultsController()
    }

    func isModelEmpty() -> Bool {
        return model == RecentActivitiesViewStructure(
            todaysActivites: [],
            currentMonthActivities: [],
            recentMonthActivities: [:]
        )
    }

    private func sortActivites(activities: [ActivityItem]) {
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
        self.model =  .init(
            todaysActivites: todaysActivities,
            currentMonthActivities: currentMonthActivities,
            recentMonthActivities: recentMonthsActivities
        )
    }

    private func setupFetchResultsController() {
        retainedReultsController = activityService.fetch()
        retainedReultsController?.delegate = self
        let activities = retainedReultsController?.fetchedObjects ?? []
        sortActivites(activities: activities)
    }

    func controller(
        _ controller: NSFetchedResultsController<any NSFetchRequestResult>,
        didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
            let activities = retainedReultsController?.fetchedObjects ?? []
            sortActivites(activities: activities)
        }

    @MainActor
    func deleteActivities() {
        activityService.deleteAll()
        analyticsService.track(
            event: .clearRecentActivity()
        )
    }

    func buildSections() -> [GroupedListSection] {
        model.recentMonthActivities.keys
            .sorted { $0 > $1 }
            .map {
                let items = model.recentMonthActivities[$0]
                return GroupedListSection(
                    heading: $0.title,
                    rows: items?.map(returnActivityRow) ?? [],
                    footer: nil
                )
            }
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
