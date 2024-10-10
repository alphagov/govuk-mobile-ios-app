import Foundation

 struct RecentActivitiesViewStructure: Equatable {
     let todaysActivites: [ActivityItem]
     let currentMonthActivities: [ActivityItem]
     let recentMonthActivities: [MonthGroupKey: [ActivityItem]]

     var sections: [GroupListSection] {
         let localSections = [
            GroupListSection(
                title: "Today",
                items: todaysActivites.map { .init(activity: $0) }
            ),
            GroupListSection(
                title: "This month",
                items: currentMonthActivities.map { .init(activity: $0) }
            )
         ] + orderedRecents()
         return localSections.filter { !$0.items.isEmpty }
     }

     private func orderedRecents() -> [GroupListSection] {
         recentMonthActivities.keys
             .sorted { $0 > $1 }
             .map {
                 let items = recentMonthActivities[$0]
                 return GroupListSection(
                    title: $0.title,
                    items: (items?.map { item in .init(activity: item) }) ?? []
                 )
             }
     }
 }
