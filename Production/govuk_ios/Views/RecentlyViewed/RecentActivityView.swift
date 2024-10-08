import SwiftUI
import CoreData

struct RecentActivityView: View {
    @ObservedObject var viewModel: RecentActivityViewModel
    let lastVisitedFormatter = DateFormatter.recentActivityLastVisited
    @State private var showingAlert: Bool = false

    init(viewModel: RecentActivityViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            if viewModel.model.todaysActivites.count >= 1 {
                let rows = viewModel.model.todaysActivites.map({
                    activityRow(activityItem: $0)
                })
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
                    .map { activityRow(activityItem: $0) }
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
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAlert.toggle()
                } label: {
                    Text("Clear")
                }.alert(isPresented: $showingAlert, content: {
                    Alert(title: Text("Are you sure you want to clear history"),
                          dismissButton: Alert.Button.cancel(
                            Text("Clear"), action: {
                                withAnimation {
                                    viewModel.deleteActivities()
                                }
                            }
                          )
                    )
                })
            }
        }
    }

    private func activityRow(activityItem: ActivityItem) -> LinkRow {
        LinkRow(
            id: activityItem.id,
            title: activityItem.title,
            body: lastVisitedString(activity: activityItem),
            action: {
                viewModel.navigateToBrowser(item: activityItem)
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
