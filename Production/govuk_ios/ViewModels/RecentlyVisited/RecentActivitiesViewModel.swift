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

    let toolbarTitle = String.recentActivity.localized(
        "editButtonTitle"
    )

    let navigationTitle = String.recentActivity.localized(
        "recentActivityNavigationTitleLabel"
    )

    func itemSelected(item: ActivityItem) {
        item.date = Date()
        try? item.managedObjectContext?.save()
        guard let url = URL(string: item.url) else { return }
        urlOpener.openIfPossible(url)
        trackRecentActivity(activity: item)
    }

    func sortActivites(activities: [ActivityItem]) -> RecentActivitiesViewStructure {
        var todaysActivities: [ActivityItem]  = []
        var currentMonthActivities: [ActivityItem]  = []
        var recentMonthsActivities: [MonthGroupKey: [ActivityItem]] = [:]
        let todaysDate = Date()
        for recentActivity in activities {
            if recentActivity.date.isToday() {
                todaysActivities.append(recentActivity)
            } else if recentActivity.date.isThisMonth() {
                currentMonthActivities.append(recentActivity)
            } else {
                let key = MonthGroupKey(date: recentActivity.date)
                var items = recentMonthsActivities[key] ?? []
                items.append(recentActivity)
                recentMonthsActivities[key] = items
            }
        }

        return RecentActivitiesViewStructure(
            todaysActivites: todaysActivities,
            currentMonthActivities: currentMonthActivities,
            recentMonthActivities: recentMonthsActivities
        )
    }

    func trackRecentActivity(activity: ActivityItem) {
        analyticsService.track(
            event: AppEvent.recentActivity(activity: activity.title)
        )
    }

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }

    private func removeDuplicateRecentMonthStrings(array: [String]) -> [String] {
        var uniqueElements: [String] = []
        for item in array where !uniqueElements.contains(item) {
            uniqueElements.append(item)
        }
        return uniqueElements
    }
}
