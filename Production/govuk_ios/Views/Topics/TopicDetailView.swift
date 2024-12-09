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
            ScrollView {
                VStack {
                    titleView
                    if let errorViewModel = viewModel.errorViewModel {
                        AppErrorView(viewModel: errorViewModel)
                            .padding(.top, 12)
                        Spacer()
                    } else {
                        topicDetails
                    }
                }
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
                .accessibility(addTraits: .isHeader)
            Spacer()
        }
        .padding(.leading, 16)
        .padding(.bottom, 4)
    }

    private var topicDetails: some View {
        VStack {
            if let description = viewModel.description {
                descripitonView(description: description)
                    .padding(.top, 2)
            }
            GroupedList(
                content: viewModel.sections,
                backgroundColor: UIColor.govUK.fills.surfaceBackground
            )
            .padding(.top, 16)
        }
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
