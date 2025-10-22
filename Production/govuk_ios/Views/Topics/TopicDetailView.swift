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
                showErrorView(with: errorViewModel)
            } else if viewModel.isLoaded {
                showLoadedContent()
            } else {
                showLoadingView()
            }
        }
        .background(Color(UIColor.govUK.fills.surfaceBackground))
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

    private func showErrorView(with errorViewModel: AppErrorViewModel) -> some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    titleView
                    Spacer()
                    AppErrorView(viewModel: errorViewModel)
                    Spacer()
                }
                .background(Color(UIColor.govUK.fills.surfaceBackground))
                .frame(minHeight: geometry.size.height)
            }
            .background(gradient)
        }
    }

    private func showLoadedContent() -> some View {
        ScrollView {
            VStack(spacing: 0) {
                titleView
                topicDetails
                subtopics
            }
        }
        .background(gradient)
    }

    private func showLoadingView() -> some View {
        VStack(spacing: 0) {
            titleView
            ZStack {
                Color(UIColor.govUK.fills.surfaceBackground)
                ProgressView()
                    .accessibilityLabel(String.topics.localized("loading"))
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
            GroupedList(
                content: viewModel.sections,
                backgroundColor: UIColor.govUK.fills.surfaceBackground
            )
            .background(Color(UIColor.govUK.fills.surfaceBackground))
    }

    private var subtopics: some View {
        VStack(spacing: 8) {
            HStack {
                Text(LocalizedStringResource("topicDetailSubtopicsHeader", table: "Topics"))
                    .font(.govUK.title3Semibold)
                    .foregroundStyle(Color(UIColor.govUK.text.primary))
                    .accessibilityAddTraits(.isHeader)
                Spacer()
            }
            .padding(.vertical, 8)
            ForEach(viewModel.subtopicCards) { cardModel in
                ListCardView(viewModel: cardModel)
            }
        }
        .padding()
        .background(Color(UIColor.govUK.fills.surfaceBackground))
        .opacity(viewModel.subtopicCards.isEmpty ? 0 : 1)
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

    private var gradient: Gradient {
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
                location: 1)
        ])
    }
}

extension TopicDetailView: TrackableScreen {
    var trackingTitle: String? { viewModel.title }
    var trackingName: String { viewModel.title }
}
