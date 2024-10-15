import SwiftUI
import CoreData

struct RecentActivityView: View {
    @ObservedObject var viewModel: RecentActivitiesViewModel
    let lastVisitedFormatter = DateFormatter.recentActivityLastVisited
    @State private var showingAlert: Bool = false

    init(viewModel: RecentActivitiesViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            if viewModel.isModelEmpty() {
                RecentActivityErrorView()
            } else {
                if !viewModel.model.todaysActivites.isEmpty {
                    let rows = viewModel.model.todaysActivites.map({
                        viewModel.returnActivityRow(activityItem: $0)
                    })
                    GroupedList(
                        content: [
                            GroupedListSection(
                                heading: viewModel.todaysActivitieslistTitle,
                                rows: rows,
                                footer: nil
                            )
                        ]
                    )
                }
                if !viewModel.model.currentMonthActivities.isEmpty {
                    let rows = viewModel.model.currentMonthActivities
                        .map { viewModel.returnActivityRow(activityItem: $0) }
                    GroupedList(
                        content: [
                            GroupedListSection(
                                heading: viewModel.currentMonthActivitiesListTitle,
                                rows: rows,
                                footer: nil
                            )
                        ]
                    )
                }
                if !viewModel.model.recentMonthActivities.isEmpty {
                    GroupedList(content: viewModel.buildSections())
                }
            }
        }.onAppear {
            viewModel.trackScreen(screen: self)
        }
        .navigationTitle(viewModel.navigationTitle)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAlert.toggle()
                } label: {
                    Text(viewModel.toolbarButtonTitle)
                }.opacity(viewModel.isModelEmpty() ? 0 : 1)
                    .alert(isPresented: $showingAlert, content: {
                        Alert(
                            title: Text(viewModel.alertTitle),
                            message: Text(viewModel.alertDescription),
                            primaryButton: .destructive(
                                Text(viewModel.alertPrimaryButtonTitle)) {
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
