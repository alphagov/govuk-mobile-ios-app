import Foundation

 struct RecentActivitiesViewStructure: Equatable {
     var todaysActivites: [ActivityItem]
     var currentMonthActivities: [ActivityItem]
     var recentMonthActivities: [MonthGroupKey: [ActivityItem]]
 }
