import Foundation
import CoreData
import SwiftUI
import UIKit

class RecentActivitiesViewModel: ObservableObject {
    private let analyticsService: AnalyticsServiceInterface
    private let urlOpener: URLOpener

    init(analyticsService: AnalyticsServiceInterface, urlOpener: URLOpener) {
        self.urlOpener = urlOpener
        self.analyticsService = analyticsService
    }

    let toolbarTitle = String.recentActivities.localized(
        "editButtonTitle"
    )
    let navigationTitle = String.recentActivities.localized(
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
        var recentMonthsActivities: [ActivityItem] = []
        var recentMonthActivityDates: [String] = []
        let todaysDate = Date()
        let recentActivities = Array(activities)
        for recentActivity in recentActivities {
            if DateHelper.checkDatesAreTheSame(dateOne: recentActivity.date,
                                               dateTwo: todaysDate) {
                todaysActivities.append(recentActivity)
            } else if DateHelper.checkEqualityOfMonthAndYear(
                dateOne: recentActivity.date,
                dateTwo: todaysDate) {
                currentMonthActivities.append(recentActivity)
            } else {
                recentMonthActivityDates.append(
                    DateHelper.getMonthAndYear(date: recentActivity.date)
                )
                recentMonthsActivities.append(recentActivity)
            }
        }

        return RecentActivitiesViewStructure(
            todaysActivites: todaysActivities,
            currentMonthActivities: currentMonthActivities,
            recentMonthActivities: recentMonthsActivities,
            recentMonthsActivityDates: removeDuplicateRecentMonthStrings(
                array: recentMonthActivityDates
            )
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
