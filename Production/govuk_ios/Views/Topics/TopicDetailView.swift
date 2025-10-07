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
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        titleView
                        topicDetails
                    }
                }
                .background(
                    Gradient(stops: [
                        .init(
                            color: viewModel.isLoaded ?
                            Color(UIColor.govUK.fills.surfaceHomeHeaderBackground) : .clear,
                            location: 0),
                        .init(
                            color: viewModel.isLoaded ?
                            Color(UIColor.govUK.fills.surfaceHomeHeaderBackground) : .clear,
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
            // isLoaded == true on back navigation, otherwise e-commerce
            // triggered in .onChange
            if viewModel.isLoaded {
                viewModel.trackEcommerce()
            }
        }
        .onChange(of: viewModel.isLoaded) { isLoaded in
            if isLoaded {
                viewModel.trackEcommerce()
            }
        }
    }

    private var titleView: some View {
        VStack(spacing: 0) {
            HStack {
                Text(viewModel.title)
                    .font(.govUK.largeTitleBold)
                    .multilineTextAlignment(.leading)
                    .accessibility(addTraits: .isHeader)
                    .foregroundColor(Color(UIColor.govUK.text.header))
                Spacer()
            }
            .padding(.leading, 16)
            .padding(.bottom, viewModel.description == nil ? 8 : 0)
            .background(Color(UIColor.govUK.fills.surfaceHomeHeaderBackground))
            if let description = viewModel.description {
                descriptionView(description: description)
            }
        }
    }

    private var topicDetails: some View {
        VStack {
            GroupedList(
                content: viewModel.sections,
                backgroundColor: UIColor.govUK.fills.surfaceBackground
            )
            .padding(.top, 16)
        }
        .background(Color(UIColor.govUK.fills.surfaceBackground))
    }

    private func descriptionView(description: String) -> some View {
        HStack {
            Text(description)
                .font(.govUK.title3)
                .foregroundColor(Color(UIColor.govUK.text.header))
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .padding(.horizontal, 18)
        .padding(.top, 8)
        .padding(.bottom, 16)
        .background(Color(UIColor.govUK.fills.surfaceHomeHeaderBackground))
    }
}

extension TopicDetailView: TrackableScreen {
    var trackingTitle: String? { viewModel.title }
    var trackingName: String { viewModel.title }
}
