import Foundation

 struct RecentActivitiesViewStructure: Equatable {
     let todaysActivites: [ActivityItem]
     let currentMonthActivities: [ActivityItem]
     let recentMonthActivities: [MonthGroupKey: [ActivityItem]]
 }
