import Foundation

 struct RecentActivitiesViewStructure: Equatable {
    let todaysActivites: [ActivityItem]
    let currentMonthActivities: [ActivityItem]
    let recentMonthActivities: [ActivityItem]
    let recentMonthsActivityDates: [String]
 }
