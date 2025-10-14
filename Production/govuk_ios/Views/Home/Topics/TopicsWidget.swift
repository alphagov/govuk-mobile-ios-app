import SwiftUI
import UIComponents
import GOVKit

struct TopicsWidget: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: TopicsWidgetViewModel
    @State var showingEditScreen: Bool = false
    @ScaledMetric var scale: CGFloat = 1
    private let columns = [
        GridItem(.flexible(), spacing: nil, alignment: .leading),
        GridItem(.flexible(), spacing: nil, alignment: .leading)
    ]

    var body: some View {
        if viewModel.fetchTopicsError {
            VStack {
                HStack {
                    Text(String.home.localized("topicsWidgetTitleCustomised"))
                        .font(Font.govUK.title3Semibold)
                    Spacer()
                }
                AppErrorView(
                    viewModel: self.viewModel.topicErrorViewModel
                )
                Spacer()
            }
            .padding(.horizontal)
        } else {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(viewModel.widgetTitle)
                            .font(Font.govUK.title3Semibold)
                            .foregroundColor(Color(UIColor.govUK.text.primary))
                            .padding([.leading], 4)
                        Spacer()
                        Button(
                            action: {
                                showingEditScreen.toggle()
                            }, label: {
                                Text(viewModel.editButtonTitle)
                                    .foregroundColor(
                                        Color(UIColor.govUK.text.buttonSecondary)
                                    )
                                    .font(Font.govUK.subheadlineSemibold)
                            }
                        )
                    }
                }
                LazyVGrid(columns: columns, alignment: .center) {
                    ForEach(viewModel.topicsToBeDisplayed, id: \.self) { topic in
                        TopicCard(model: topic)
                            .background(Color(uiColor: UIColor.govUK.fills.surfaceCardBlue))
                            .roundedBorder(
                                cornerRadius: 10,
                                borderColor: Color(uiColor: UIColor.govUK.strokes.cardBlue),
                                borderWidth: 1
                            )
                            .onTapGesture {
                                viewModel.trackECommerceSelection(topic.title)
                                viewModel.topicAction(topic)
                            }
                    }
                }
                if !viewModel.showAllTopicsButton {
                    HStack {
                        Spacer()
                        SwiftUIButton(
                            .compact,
                            viewModel: viewModel.showAllButtonViewModel
                        )
                        .frame(width: 150 * scale)
                        Spacer()
                    }
                    .padding(.top)
                }
            }
            .padding(.horizontal)
            .sheet(isPresented: $showingEditScreen,
                    onDismiss: {
                viewModel.fetchTopics()
                viewModel.fetchDisplayedTopics()
                viewModel.updateShowAllButtonVisibility()
                viewModel.trackECommerce()
            }, content: {
                NavigationView {
                    EditTopicsView(
                        viewModel: viewModel.editTopicViewModel
                    )
                }
                .id(colorScheme)
            })
            .onAppear {
                viewModel.fetchTopics()
                viewModel.fetchDisplayedTopics()
                viewModel.updateShowAllButtonVisibility()
                if !self.viewModel.initialLoadComplete {
                    self.viewModel.initialLoadComplete = true
                    self.viewModel.trackECommerce()
                }
            }
        }
    }
}
