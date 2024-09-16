import Foundation
import CoreData
import SwiftUI
import UIKit

class RecentActivitiesViewModel: ObservableObject {
    private let analyticsService: AnalyticsServiceInterface

    init(analyticsService: AnalyticsServiceInterface) {
        self.analyticsService = analyticsService
    }

    let navigationTitle = NSLocalizedString(
        "recentActivityNavigationTitleLabel",
        bundle: .main,
        comment: ""
    )
    let toolbarTitle = NSLocalizedString(
        "editButtonTitle",
        bundle: .main,
        comment: ""
    )

    func itemSelected(item: ActivityItem) {
        item.date = Date()
        do {
            try item.managedObjectContext?.save()
        } catch { }
        guard let url = URL(string: item.url) else { return }
        UIApplication.shared.open(url)
        trackRecentActivity(activity: item)
    }

    func sortActivites(activities: FetchedResults<ActivityItem>) -> RecentActivitiesViewStructure {
        var todaysActivities: [ActivityItem]  = []
        var currentMonthActivities: [ActivityItem]  = []
        var recentMonthsActivities: [ActivityItem] = []
        var recentMonthActivityDates: [String] = []
        let todaysDate = Date()
        var recentActivities: [ActivityItem] = activities.map { $0 }
        DateHelper.sortDate(dates: &recentActivities)
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
                array: recentMonthActivityDates))
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
