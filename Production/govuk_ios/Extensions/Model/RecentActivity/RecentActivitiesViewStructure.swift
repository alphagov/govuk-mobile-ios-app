import Foundation
import CoreData

 struct RecentActivitiesViewStructure: Equatable {
     let todaysActivites: [NSManagedObjectID]
     let currentMonthActivities: [NSManagedObjectID]
     let recentMonthActivities: [MonthGroupKey: [NSManagedObjectID]]

     var sections: [RecentActivitySection] {
         let localSections = [
            RecentActivitySection(
                title: String.recentActivity.localized("recentActivitiesTodaysListTitle"),
                items: todaysActivites
            ),
            RecentActivitySection(
                title: String.recentActivity.localized("recentActivityCurrentMonthItems"),
                items: currentMonthActivities
            )
         ] + orderedRecents()
         return localSections.filter { !$0.items.isEmpty }
     }

     private func orderedRecents() -> [RecentActivitySection] {
         recentMonthActivities.keys
             .sorted { $0 > $1 }
             .map {
                 let items = recentMonthActivities[$0]
                 return RecentActivitySection(
                    title: $0.title,
                    items: items ?? []
                 )
             }
     }

    var isEmpty: Bool {
        todaysActivites.isEmpty &&
        currentMonthActivities.isEmpty &&
        recentMonthActivities.isEmpty
     }
 }
