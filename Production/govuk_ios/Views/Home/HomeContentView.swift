import SwiftUI
import GOVKit

struct HomeContentView: View {
    @StateObject var viewModel: HomeViewModel
    @Namespace var topID

    private let scrollViewCoordinateSpace = "scroll"

    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView {
                    EmptyView()
                        .id(topID)
                    ForEach(viewModel.widgets) { widget in
                        widget
                    }
                    ScrollBottomIndicatorView(scrollViewHeight: geometry.size.height,
                                            scrollViewCoordinateSpace: scrollViewCoordinateSpace)
                }
                .onChange(of: viewModel.homeContentScrollToTop) { shouldScroll in
                    if shouldScroll {
                        withAnimation {
                            proxy.scrollTo(topID, anchor: .top)
                        }
                        viewModel.homeContentScrollToTop = false
                    }
                }
                .coordinateSpace(name: scrollViewCoordinateSpace)
            }.onAppear {
                viewModel.updateWidgets()
            }
            .background(Color(uiColor: UIColor.govUK.fills.surfaceBackground))
        }
    }
}
