import SwiftUI
import UIComponents

struct RecentActivityContainerView: View {
    @ObservedObject private var viewModel: RecentActivitiesContainerViewModel
    @FetchRequest(fetchRequest: ActivityItem.fetchRequest()) private var recentItems

    init(viewModel: RecentActivitiesContainerViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            switch recentItems.count {
            case 0:
                RecentActivityErrorView()
            case (let count) where count >= 1:
                RecentActivityView(
                    viewModel: RecentActivitiesViewModel(
                        model: viewModel.sortActivites(
                            activities: Array(recentItems)
                        ),
                        urlOpener: UIApplication.shared
                    )
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
