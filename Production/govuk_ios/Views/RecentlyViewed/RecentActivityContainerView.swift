import SwiftUI
import UIComponents

struct RecentActivityContainerView: View, TrackableScreen {
    @StateObject private var viewModel: RecentActivitiesViewModel
    @FetchRequest(fetchRequest: ActivityItem.all()) private var recentItems

    init(viewModel: RecentActivitiesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        viewModel.trackScreen(screen: self)
    }

    var body: some View {
        VStack {
            switch recentItems.count {
            case 0:
                RecentActivityErrorView()
                    .navigationTitle(viewModel.navigationTitle)
            case (let count) where count >= 1:
                RecentActivityView(
                    model: viewModel.sortActivites(
                        activities: Array(recentItems)
                    ),
                    selected: { item in self.viewModel.itemSelected(item: item) }
                )
                .navigationTitle(viewModel.navigationTitle)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Text(viewModel.toolbarTitle) .foregroundColor(
                            Color(UIColor.govUK.text.link))
                    }
                }
            default:
                ProgressView()
            }
        }.onAppear {
            viewModel.trackScreen(screen: self)
        }
    }}

extension RecentActivityContainerView {
    var trackingTitle: String? { "Pages you've visited" }
    var trackingName: String { "Pages you've visited" }
    var trackingClass: String {
        String(
            describing: type(of: self)
        )
    }
}
