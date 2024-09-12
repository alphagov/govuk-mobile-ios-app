import SwiftUI
import UIComponents

struct RecentItemsViewContainer: View {
    @StateObject private var viewModel: RecentItemsViewModel
    @FetchRequest(fetchRequest: ActivityItem.all()) private var recentItems
    init(viewModel: RecentItemsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
       // NavigationView {
            switch recentItems.count {
            case 0:
                RecentItemsErrorView()
                    .navigationTitle(viewModel.navigationTitle)
            case (let count) where count >= 1:
                RecentItemsView(model: viewModel.sortItems(visitedItems: recentItems))
                    .navigationTitle(viewModel.navigationTitle)
                 // .navigationBarHidden(false)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Text(viewModel.toolbarTitle) .foregroundColor(Color(UIColor.govUK.text.link))
                        }
                    }
            default:
                ProgressView()
            }
        // }
    }
}
