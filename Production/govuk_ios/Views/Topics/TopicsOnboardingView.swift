import SwiftUI
import GOVKit

struct TopicsOnboardingView: View {
    @StateObject private var viewModel: TopicsOnboardingViewModel

    init(viewModel: TopicsOnboardingViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                Text(viewModel.subtitle)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 12)
                    .padding(.top, 10)
                topicsList
                    .padding([.top, .horizontal], 16)
            }
            ButtonStackView(
                primaryButtonViewModel: viewModel.primaryButtonViewModel,
                primaryDisabled: !viewModel.isTopicSelected,
                secondaryButtonViewModel: viewModel.secondaryButtonViewModel
            )
            .background(Color(UIColor.govUK.fills.surfaceFixedContainer))
        }
        .background(Color(UIColor.govUK.fills.surfaceFullScreen))
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(
            Color(UIColor.govUK.fills.surfaceFullScreen),
            for: .navigationBar
        )
        .onAppear {
            viewModel.trackScreen(screen: self)
        }
    }

    private var topicsList: some View {
        VStack(spacing: 16) {
            ForEach(viewModel.topicSelectionCards) { topicSelectionCard in
                TopicSelectionCardView(viewModel: topicSelectionCard)
            }
        }
    }
}

extension TopicsOnboardingView: TrackableScreen {
    var trackingTitle: String? { "Select relevant topics" }
    var trackingName: String { "Select relevant topics" }
}
