import SwiftUI
import UIComponents

struct TopicDetailView<T: TopicDetailViewModelInterface>: View {
    @StateObject var viewModel: T
    @State private var isScrolled = false

    init(viewModel: T) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color(UIColor.govUK.fills.surfaceBackground)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                titleView
                Divider().opacity(isScrolled ? 1.0 : 0.0)
                ScrollView {
                    VStack {
                        if let description = viewModel.description {
                            descripitonView(description: description)
                                .padding(.top, 8)
                        }
                        GroupedList(
                            content: viewModel.sections,
                            backgroundColor: UIColor.govUK.fills.surfaceBackground
                        )
                        .padding(.top, 16)
                    }
                    .background(GeometryReader { geometry in
                        Color.clear.preference(key: ScrollOffsetPreferenceKey.self,
                                               value: geometry
                            .frame(in: .named("ScrollView")).origin.y)
                    })
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        isScrolled = value < 0.0
                    }
                }
                .coordinateSpace(name: "ScrollView")
            }
        }
        .onAppear {
            viewModel.trackScreen(screen: self)
        }
    }

    private var titleView: some View {
        HStack {
            Text(viewModel.title)
                .font(.govUK.largeTitleBold)
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .padding(.leading, 16)
        .padding(.bottom, 8)
    }

    private func descripitonView(description: String) -> some View {
        HStack {
            Text(description)
                .font(.govUK.subheadline)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 18)
            Spacer()
        }
    }
}

extension TopicDetailView: TrackableScreen {
    var trackingTitle: String? { viewModel.title }
    var trackingName: String { viewModel.title }
}
