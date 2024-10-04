import SwiftUI
import UIComponents

struct RecentActivityContainerView: View {
    @StateObject private var viewModel: RecentActivitiesViewModel
    @FetchRequest(fetchRequest: ActivityItem.fetchRequest()) private var recentItems

    init(viewModel: RecentActivitiesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            switch recentItems.count {
            case 0:
                RecentActivityErrorView()
            case (let count) where count >= 1:
                RecentActivityView(
                    model: viewModel.sortActivites(
                        activities: Array(recentItems)
                    ),
                    selected: { self.viewModel.selected(item: $0) }
                )
            default:
                ProgressView()
            }
        }.navigationTitle(viewModel.navigationTitle)
            .onAppear {
                viewModel.trackScreen(screen: self)
            }
    }
}

extension RecentActivityContainerView: TrackableScreen {
    var trackingTitle: String? { "Pages you've visited" }
    var trackingName: String { "Pages you've visited" }
}
