import SwiftUI
import CoreData

struct RecentActivityView: View {
    let model: RecentActivitiesViewStructure
    let selected: (ActivityItem) -> Void
    @Environment(\.managedObjectContext) private var context

    init(model: RecentActivitiesViewStructure,
         selected: @escaping (ActivityItem) -> Void) {
        self.model = model
        self.selected = selected
    }

    var body: some View {
        ScrollView {
            if model.todaysActivites.count >= 1 {
                let rows = model.todaysActivites.map({ activityRow(activityItem: $0) })
                GroupedList(content: [GroupedListSection(
                    heading: String.recentActivities.localized(
                        "recentActivitiesTodaysListTitle"
                    ),
                    rows: rows,
                    footer: nil
                )]
                )
            }
            if model.currentMonthActivities.count >= 1 {
                let rows = model.currentMonthActivities.map({ activityRow(activityItem: $0) })
                GroupedList(content: [GroupedListSection(
                    heading: String.recentActivities.localized(
                        "recentActivityCurrentMonthItems"
                    ),
                    rows: rows,
                    footer: nil
                )]
                )
            }
            if model.recentMonthActivities.count >= 1 {
                GroupedList(content: buildSectionsView())
            }
        }
    }

    private func activityRow(activityItem: ActivityItem) -> LinkRow {
        LinkRow(
            id: activityItem.id,
            title: activityItem.title,
            body: activityItem.formattedDate,
            action: {
                self.selected(activityItem)
            }
        )
    }

    private func buildSectionsView() -> [GroupedListSection] {
        var groupedSections: [GroupedListSection] = []
        for dateString in model.recentMonthsActivityDates {
            let filteredArray = model.recentMonthActivities.filter { item in
                DateHelper.getMonthAndYear(
                    date: item.date) == dateString
            }
            let rows = filteredArray.map(
                { activityRow(activityItem: $0) }
            )
            let groupSection = GroupedListSection(heading: dateString,
                                                  rows: rows,
                                                  footer: nil
            )
            groupedSections.append(groupSection)
        }
        return groupedSections
    }
}
