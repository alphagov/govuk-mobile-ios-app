import SwiftUI
import CoreData

struct RecentActivityView: View {
    @ObservedObject var viewModel: RecentActivityViewModel
    let lastVisitedFormatter = DateFormatter.recentActivityLastVisited
    @Environment(\.managedObjectContext) private var context
    @State private var editMode: Bool = false


    init(viewModel: RecentActivityViewModel) {
        // _viewModel = StateObject(wrappedValue: viewModel)
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            Text("Delete").onTapGesture {
                viewModel.deleteActivities()
            }
            if viewModel.model.todaysActivites.count >= 1 {
                let rows = viewModel.model.todaysActivites
                    .map({ editActivityRow(activityItem: $0) })
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
            if viewModel.model.currentMonthActivities.count >= 1 {
                let rows = viewModel.model.currentMonthActivities
                    .map { editActivityRow(activityItem: $0) }
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
            if viewModel.model.recentMonthActivities.count >= 1 {
                GroupedList(content: buildSectionsView())
            }
        }.toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(editMode ? "Done" : "Edit") {
                    withAnimation {
                        editMode.toggle()
                    }
//                    if editMode {
//                        viewModel.deleteActivities()
//                    }
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
            isSelected: viewModel.selectedActivities
                .contains(where: { (key: String, _: ActivityItem) in
                key == activityItem.id
                }),
            isWebLink: false,
            action: {
                viewModel.navigateToBrowser(item: activityItem)
            },
            selectAction: {
                viewModel.selectAcvtivity(activity: activityItem)
            }
        )
    }

    private func buildSectionsView() -> [GroupedListSection] {
        viewModel.model.recentMonthActivities.keys
            .sorted { $0 > $1 }
            .map {
                let items = viewModel.model.recentMonthActivities[$0]
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
