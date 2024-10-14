import UIKit
import CoreData
import Foundation
import SwiftUI
import Factory

class RecentActivitiesViewModel: NSObject,
                                 ObservableObject,
                                 NSFetchedResultsControllerDelegate {
    @Inject(\.activityService) private(set) var activityService: ActivityServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    @Published var model: RecentActivitiesViewStructure = RecentActivitiesViewStructure(
        todaysActivites: [],
        currentMonthActivities: [],
        recentMonthActivities: [:]
    )
    private let lastVisitedFormatter = DateFormatter.recentActivityLastVisited
    private let recentActivityHeaderFormatter = DateFormatter.recentActivityHeader
    private let urlOpener: URLOpener
    @Published var activities: [ActivityItem] = []

    init(urlOpener: URLOpener,
         analyticsService: AnalyticsServiceInterface) {
        self.urlOpener = urlOpener
        self.analyticsService = analyticsService
        super.init()
        setupFetchResultsController()
    }

    lazy var fetchActivities: NSFetchedResultsController = {
        var controller = NSFetchedResultsController(
            fetchRequest: ActivityItem.fetchRequest(),
            managedObjectContext: self.activityService.returnContext(),
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        return controller
    }()

    func isModelEmpty() -> Bool {
        return model == RecentActivitiesViewStructure(
            todaysActivites: [],
            currentMonthActivities: [],
            recentMonthActivities: [:]
        )
    }

    func sortActivites(activities: [ActivityItem]) {
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
        fetchActivities.delegate = self
        try? fetchActivities.performFetch()
        let activities = fetchActivities.fetchedObjects ?? []
        sortActivites(activities: activities)
    }

    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            self.model = RecentActivitiesViewStructure(
                todaysActivites: [],
                currentMonthActivities: [],
                recentMonthActivities: [:]
            )
            let activities = fetchActivities.fetchedObjects ?? []
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
