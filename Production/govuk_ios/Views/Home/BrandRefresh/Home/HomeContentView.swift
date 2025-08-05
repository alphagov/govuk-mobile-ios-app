import SwiftUI

struct HomeContentView: View {
    @StateObject var viewModel: HomeViewModel
    @Namespace var topID

    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                EmptyView()
                    .id(topID)
                TopicsView(
                    viewModel: viewModel.topicsWidgetViewModel
                )
            }.onChange(of: viewModel.homeContentScrollToTop) { shouldScroll in
                print(shouldScroll)
                if shouldScroll {
                    withAnimation {
                        proxy.scrollTo(topID, anchor: .top)
                    }
                    viewModel.homeContentScrollToTop = false
                }
            }
        }
    }
}
