import SwiftUI
import UIComponents

struct TopicDetailView<T: TopicDetailViewModelInterface>: View {
    @StateObject var viewModel: T

    init(viewModel: T) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color(UIColor.govUK.fills.surfaceBackground)
                .ignoresSafeArea()
            VStack {
                ScrollView {
                    if let description = viewModel.description {
                        descripitonView(description: description)
                    }
                    GroupedList(
                        content: viewModel.sections,
                        backgroundColor: UIColor.govUK.fills.surfaceBackground
                    )
                    .padding(.top, 16)
                }
            }
        }
        .onAppear {
            viewModel.trackScreen(screen: self)
        }
    }

    private func descripitonView(description: String) -> some View {
        HStack {
            Text(description)
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
