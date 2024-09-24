import SwiftUI
import UIComponents

struct RecentActivityContainerView: View, TrackableScreen {
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
                    selected: { item in self.viewModel.itemSelected(item: item) }
                )
                .accessibilityLabel(
                    Text(viewModel.navigationTitle)
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

extension RecentActivityContainerView {
    var trackingTitle: String? { "Pages you've visited" }
    var trackingName: String { "Pages you've visited" }
    var trackingClass: String {
        String(
            describing: type(of: self)
        )
    }
}
