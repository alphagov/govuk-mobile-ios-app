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
        guard let url = URL(string: item.url)
        else { return }
        item.date = Date()
        try? item.managedObjectContext?.save()
        urlOpener.openIfPossible(url)
        trackSelection(activity: item)
    }

    private func urlFromLink(_ link: String) -> URL? {
        var components = URLComponents(string: link)
        let scheme = components?.scheme
        components?.scheme = scheme ?? "https"
        let host = components?.host
        components?.host = host ?? "www.gov.uk"

        return components?.url
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
