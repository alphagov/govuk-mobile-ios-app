import Foundation
import CoreData
import SwiftUI
import UIKit

class RecentActivitiesViewModel: ObservableObject {
    private let analyticsService: AnalyticsServiceInterface
    private let urlOpener: URLOpener
    private let recentActivityHeaderFormatter = DateFormatter.recentActivityHeader

    init(analyticsService: AnalyticsServiceInterface,
         urlOpener: URLOpener) {
        self.urlOpener = urlOpener
        self.analyticsService = analyticsService
    }

    let navigationTitle = String.recentActivity.localized(
        "recentActivityNavigationTitle"
    )

    func selected(item: ActivityItem) {
        item.date = Date()
        try? item.managedObjectContext?.save()
        guard let url = URL(string: item.url) else { return }
        urlOpener.openIfPossible(url)
        trackSelection(activity: item)
    }

    func sortActivites(activities: [ActivityItem]) -> RecentActivitiesViewStructure {
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
