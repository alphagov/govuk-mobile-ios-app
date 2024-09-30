import SwiftUI
import CoreData

struct RecentActivityView: View {
    let model: RecentActivitiesViewStructure
    let goToLinkAction: (ActivityItem) -> Void
    let selectActivityAction: (ActivityItem) -> Void
    let deleteSelectedActivitiesAction: () -> Void
    let lastVisitedFormatter = DateFormatter.recentActivityLastVisited
    @Environment(\.managedObjectContext) private var context
    @State var editMode: Bool = false

    init(model: RecentActivitiesViewStructure,
         goToLinkAction: @escaping (ActivityItem) -> Void,
         selectActivityAction: @escaping (ActivityItem) -> Void,
         deletedSelectedActivities: @escaping() -> Void) {
        self.model = model
        self.goToLinkAction = goToLinkAction
        self.selectActivityAction = goToLinkAction
        self.deleteSelectedActivitiesAction = deletedSelectedActivities
    }

    var body: some View {
        ScrollView {
            if model.todaysActivites.count >= 1 {
                let rows = model.todaysActivites.map({ editActivityRow(activityItem: $0) })
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
                let rows = model.currentMonthActivities.map { editActivityRow(activityItem: $0) }
                GroupedList(
                    content: [
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
        }.toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(editMode ? "Done" : "Edit") {
                    withAnimation {
                        editMode.toggle()
                    }
                    if editMode {
                        deleteSelectedActivitiesAction()
                    }
                }
            }
        }
    }

    private func editActivityRow(activityItem: ActivityItem) -> EditLinkRow {
        EditLinkRow(
            id: activityItem.id,
            editMode: editMode,
            title: activityItem.title,
            body: lastVisitedString(activity: activityItem),
            action: {
                self.goToLinkAction(activityItem)
            },
            selectAction: {
                self.selectActivityAction(activityItem)
            }
        )
    }

    private func buildSectionsView() -> [GroupedListSection] {
        model.recentMonthActivities.keys
            .sorted { $0 > $1 }
            .map {
                let items = model.recentMonthActivities[$0]
                return GroupedListSection(
                    heading: $0.title,
                    rows: items?.map(editActivityRow) ?? [],
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
