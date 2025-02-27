import SwiftUI
import UIComponents
import GOVKit

struct TopicDetailView<T: TopicDetailViewModelInterface>: View {
    @StateObject var viewModel: T

    init(viewModel: T) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            if let errorViewModel = viewModel.errorViewModel {
                ScrollView {
                    VStack {
                        titleView
                        AppErrorView(viewModel: errorViewModel)
                            .padding(.top, 12)
                        Spacer()
                    }
                }
                .padding(.bottom, 16)
            } else {
                ScrollView {
                    VStack {
                        titleView
                        topicDetails
                    }
                }
                .padding(.bottom, 16)
                .background(
                    Gradient(stops: [
                        .init(
                            color: Color(UIColor.govUK.fills.surfaceHomeHeaderBackground),
                            location: 0),
                        .init(
                            color: Color(UIColor.govUK.fills.surfaceHomeHeaderBackground),
                            location: 0.33),
                        .init(
                            color: .clear,
                            location: 0.33),
                        .init(
                            color: .clear,
                            location: 1)])
                )
            }
        }
        .onAppear {
            viewModel.trackScreen(screen: self)
        }
        .onChange(of: viewModel.sections.count) { _ in
            // Note that this change event does not fire for the Step by step screen
            // Ecommerce tracking is handled in the trackScreen event in that case
            viewModel.trackEcommerce()
        }
    }

    private var titleView: some View {
        HStack {
            Text(viewModel.title)
                .font(.govUK.largeTitleBold)
                .multilineTextAlignment(.leading)
                .accessibility(addTraits: .isHeader)
                .foregroundColor(Color(UIColor.govUK.text.header))
            Spacer()
        }
        .padding(.leading, 16)
        .padding(.bottom, 4)
        .background(Color(UIColor.govUK.fills.surfaceHomeHeaderBackground))
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
        .background(Color(UIColor.govUK.fills.surfaceBackground))
    }

    private func descripitonView(description: String) -> some View {
        HStack {
            Text(description)
                .font(.govUK.subheadline)
                .multilineTextAlignment(.leading)
                .padding(.top, 16)
                .padding(.horizontal, 18)
            Spacer()
        }
    }
}

extension TopicDetailView: TrackableScreen {
    var trackingTitle: String? { viewModel.title }
    var trackingName: String { viewModel.title }
}
