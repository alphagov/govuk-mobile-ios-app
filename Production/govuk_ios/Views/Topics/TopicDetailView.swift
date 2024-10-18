import SwiftUI
import UIComponents

struct TopicDetailView: View {
    @StateObject var viewModel: TopicDetailViewModel

    init(viewModel: TopicDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color(UIColor.govUK.fills.surfaceBackground)
                .ignoresSafeArea()
            VStack {
                ScrollView {
                    if !viewModel.shouldHideHeading {
                        descripitonView
                    }
                    GroupedList(
                        content: viewModel.sections,
                        backgroundColor: UIColor.govUK.fills.surfaceBackground
                    )
                    .padding(.top, 16)
                }
            }
        }
        .navigationTitle(viewModel.topic.title)
        .navigationBarTitleDisplayMode(viewModel.isStepByStepSubtopic ? .inline : .large)
        .onAppear {
            viewModel.trackScreen(screen: self)
        }
    }

    private var descripitonView: some View {
        HStack {
            Text(viewModel.topic.title)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 16)
            Spacer()
        }
    }
}

extension TopicDetailView: TrackableScreen {
    var trackingTitle: String? { viewModel.topic.title }
    var trackingName: String { viewModel.topic.title }
}
