import SwiftUI
import CoreData

struct RecentActivityView: View {
    let model: RecentActivitiesViewStructure
    let selected: (ActivityItem) -> Void
    let lastVisitedFormatter = DateFormatter.recentActivityLastVisited
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
                GroupedList(
                    content: [
                        GroupedListSection(
                            heading: String.recentActivity.localized(
                                "recentActivitiesTodaysListTitle"
                            ),
                            rows: rows,
                            footer: nil
                        )
                    ]
                )
            }
            if model.currentMonthActivities.count >= 1 {
                let rows = model.currentMonthActivities.map({ activityRow(activityItem: $0) })
                GroupedList(content: [
                    GroupedListSection(
                        heading: String.recentActivity.localized(
                            "recentActivityCurrentMonthItems"
                        ),
                        rows: rows,
                        footer: nil
                    )
                ]
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
            body: lastVisitedString(activity: activityItem),
            action: {
                self.selected(activityItem)
            }
        )
    }

    private func buildSectionsView() -> [GroupedListSection] {
        let keys = model.recentMonthActivities.keys
        return keys
            .sorted { $0.year > $1.year && $0.month > $1.month }
            .map {
                let items = model.recentMonthActivities[$0]
                return GroupedListSection(
                    heading: $0.title,
                    rows: items?.map(activityRow) ?? [],
                    footer: nil
                )
            }
    }

    private func lastVisitedString(activity: ActivityItem) -> String {
        let copy = String.recentActivity.localized(
            "recentActivityFormattedDateStringComponent"
        )
        let formattedDateString = lastVisitedFormatter.string(from: activity.date)
        return "\(copy) \(formattedDateString)"
    }
}
