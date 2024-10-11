// import Foundation
// import CoreData
// import SwiftUI
// import UIKit
//
// class RecentActivitiesContainerViewModel: ObservableObject {
//    let analyticsService: AnalyticsServiceInterface
//    private let urlOpener: URLOpener
//    private let recentActivityHeaderFormatter = DateFormatter.recentActivityHeader
//
//    init(analyticsService: AnalyticsServiceInterface,
//         urlOpener: URLOpener) {
//        self.urlOpener = urlOpener
//        self.analyticsService = analyticsService
//    }
//
//    let navigationTitle = String.recentActivity.localized(
//        "recentActivityNavigationTitle"
//    )
//
//    func sortActivites(activities: [ActivityItem]) -> RecentActivitiesViewStructure {
//        var todaysActivities: [ActivityItem] = []
//        var currentMonthActivities: [ActivityItem] = []
//        var recentMonthsActivities: [MonthGroupKey: [ActivityItem]] = [:]
//        for recentActivity in activities {
//            if recentActivity.date.isToday() {
//                todaysActivities.append(recentActivity)
//            } else if recentActivity.date.isThisMonth() {
//                currentMonthActivities.append(recentActivity)
//            } else {
//                let key = MonthGroupKey(
//                    date: recentActivity.date,
//                    formatter: recentActivityHeaderFormatter
//                )
//                var items = recentMonthsActivities[key] ?? []
//                items.append(recentActivity)
//                recentMonthsActivities[key] = items
//            }
//        }
//
//        return .init(
//            todaysActivites: todaysActivities,
//            currentMonthActivities: currentMonthActivities,
//            recentMonthActivities: recentMonthsActivities
//        )
//    }
//
//    func trackScreen(screen: TrackableScreen) {
//        analyticsService.track(screen: screen)
//    }
// }
