import SwiftUI
import GOVKit

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
                ForEach(viewModel.widgets) { widget in
                    widget
                }
            }
            .onChange(of: viewModel.homeContentScrollToTop) { shouldScroll in
                if shouldScroll {
                    withAnimation {
                        proxy.scrollTo(topID, anchor: .top)
                    }
                    viewModel.homeContentScrollToTop = false
                }
            }
        }.onAppear {
            viewModel.trackScreen(screen: self)
        }
        .background(Color.gray)
    }
}

extension HomeContentView: TrackableScreen {
    var trackingName: String { "Homepage" }
    var trackingTitle: String? { "Homepage" }
}
