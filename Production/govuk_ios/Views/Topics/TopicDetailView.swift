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
                    titleView
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
                }
        }
        .onAppear {
            viewModel.trackScreen(screen: self)
        }
    }

    private var titleView: some View {
        HStack {
            Text("topic detail title")
                .font(.govUK.largeTitleBold)
                .multilineTextAlignment(.leading)
                .accessibility(addTraits: .isHeader)
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
