import Foundation

 struct RecentActivitiesViewStructure: Equatable {
     let todaysActivites: [ActivityItem]
     let currentMonthActivities: [ActivityItem]
     let recentMonthActivities: [MonthGroupKey: [ActivityItem]]

     var sections: [ActivitySection] {
         let localSections = [
            ActivitySection(
                title: "Today",
                items: todaysActivites
            ),
            ActivitySection(
                title: "This month",
                items: currentMonthActivities
            )
         ] + orderedRecents()
         return localSections.filter { !$0.items.isEmpty }
     }

     private func orderedRecents() -> [ActivitySection] {
         recentMonthActivities.keys
             .sorted { $0 > $1 }
             .map {
                 let items = recentMonthActivities[$0]
                 return ActivitySection(
                    title: $0.title,
                    items: items ?? []
                 )
             }
     }
 }
