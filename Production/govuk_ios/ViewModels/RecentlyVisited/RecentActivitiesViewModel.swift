import Foundation
import CoreData
import SwiftUI
import UIKit

class RecentActivitiesViewModel: ObservableObject {
    private let analyticsService: AnalyticsServiceInterface
    private let urlOpener: URLOpener

    init(analyticsService: AnalyticsServiceInterface, URLOpener: URLOpener) {
        self.URLOpener = URLOpener
        self.analyticsService = analyticsService
    }

    let navigationTitle = "recentActivityNavigationTitleLabel".localized
    let toolbarTitle = "editButtonTitle".localized

    func itemSelected(item: ActivityItem) {
        item.date = Date()
        try? item.managedObjectContext?.save()
        guard let url = URL(string: item.url) else { return }
        URLOpener.openIfPossible(url)
        trackRecentActivity(activity: item)
    }

    func sortActivites(activities: any RandomAccessCollection) -> RecentActivitiesViewStructure {
        var todaysActivities: [ActivityItem]  = []
        var currentMonthActivities: [ActivityItem]  = []
        var recentMonthsActivities: [ActivityItem] = []
        var recentMonthActivityDates: [String] = []
        let todaysDate = Date()
        var recentActivities = Array(activities)
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
            recentMonthsActivityDates: DateHelper.removeDuplicates(
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
}
