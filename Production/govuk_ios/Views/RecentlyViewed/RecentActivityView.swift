import SwiftUI
import CoreData

struct RecentActivityView: View {
    @ObservedObject var viewModel: RecentActivitiesViewModel
    let lastVisitedFormatter = DateFormatter.recentActivityLastVisited
    @State private var showingAlert: Bool = false
    let alertTitle = String.recentActivity.localized(
        "recentActivityClearAllAlertTitle"
    )
    let alertDescription = String.recentActivity.localized(
        "recentActivityClearAllAlertWarningDesc"
    )
    let alertPrimaryButtonTitle = String.recentActivity.localized(
        "recentActivityAlertWarningConfirmation"
    )
    let alertSecondaryButtonTitle = String.recentActivity.localized(
        "recentActivityAlertDismissText"
    )
    let toolbarButtonTitle = String.recentActivity.localized(
        "recentActivityToolBarTitle"
    )

    let navigationTitle = String.recentActivity.localized(
        "recentActivityNavigationTitle"
    )

    init(viewModel: RecentActivitiesViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            if viewModel.isModelEmpty() {
                RecentActivityErrorView()
            } else {
                if viewModel.model.todaysActivites.count >= 1 {
                    let rows = viewModel.model.todaysActivites.map({
                        viewModel.returnActivityRow(activityItem: $0)
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
                        .map { viewModel.returnActivityRow(activityItem: $0) }
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
                    GroupedList(content: viewModel.buildSections())
                }
            }
        }.navigationTitle(
            String.recentActivity.localized(
                "recentActivityNavigationTitle"
            )
        )
        .onAppear {
            try? viewModel.fetchActivities.performFetch()
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAlert.toggle()
                } label: {
                    Text(toolbarButtonTitle)
                }.opacity(viewModel.isModelEmpty() ? 0 : 1)
                    .alert(isPresented: $showingAlert, content: {
                        Alert(
                            title: Text(alertTitle),
                            message: Text(alertDescription),
                            primaryButton: .destructive(Text(alertPrimaryButtonTitle)) {
                                withAnimation {
                                    viewModel.deleteActivities()
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    })
            }
        }
    }
}

extension RecentActivityView: TrackableScreen {
    var trackingTitle: String? { "Pages you've visited" }
    var trackingName: String { "Pages you've visited" }
}
