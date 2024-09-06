import SwiftUI
import UIComponents

struct RecentItemsViewContainer: View {
    @StateObject private var viewModel: RecentItemsViewModel
    init(viewModel: RecentItemsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        NavigationView {
            switch viewModel.state {
            case .error(let errorModel):
                RecentItemsErrorView(model: errorModel)
            case .loaded(let visitedItemsModel):
                RecentItemsView(model: visitedItemsModel,
                                 viewModel: viewModel)
                    .navigationTitle(viewModel.navigationTitle)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Text(viewModel.toolbarTitle) .foregroundColor(Color(UIColor.govUK.text.link))
                        }
                    }
            case .loading:
                ProgressView()
            }
        }
    }
}
