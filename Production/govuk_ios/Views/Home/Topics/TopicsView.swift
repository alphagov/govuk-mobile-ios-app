import SwiftUI
import UIComponents
import GOVKit

struct TopicsView: View {
    @StateObject var viewModel: TopicsWidgetViewModel
    @ScaledMetric var scale: CGFloat = 1
    // @State private var showingEditScreen: Bool = false
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
            }.padding()
        } else {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    HStack {
                        Text(viewModel.widgetTitle)
                            .font(Font.govUK.title3Semibold)
                            .foregroundColor(Color(UIColor.govUK.text.primary))
                            .padding([.leading], 4)
                        Spacer()
                        SwiftUIButton(.secondary, viewModel: viewModel.editButtonViewModel)
                            .frame(width: 70 * scale)
                            .padding([.leading], 40)
                    }
                    LazyVGrid(columns: columns, alignment: .center) {
                        ForEach(viewModel.topicsToBeDisplayed, id: \.self) { topic in
                            TopicCard(model: topic)
                                .background(Color(uiColor: UIColor.govUK.fills.surfaceCardBlue))
                                .roundedBorder(
                                    cornerRadius: 10,
                                    borderColor: Color(uiColor: UIColor.govUK.strokes.cardBlue),
                                    borderWidth: 1
                                ).padding(2)
                                .onTapGesture {
                                    viewModel.trackECommerceSelection(topic.title)
                                    viewModel.topicAction(topic)
                                }
                        }
                    }
                }
                if !viewModel.showAllTopicsButton {
                    HStack {
                        Spacer()
                    SwiftUIButton(
                        .compact,
                        viewModel: viewModel.showAllButtonViewModel
                    ).frame(width: 150 * scale)
                        Spacer()
                    }
                    .padding()
                }
            }.sheet(isPresented: $viewModel.showingEditScreen,
                    onDismiss: {
                viewModel.fetchTopics()
                viewModel.fetchDisplayedTopics()
                viewModel.showAllTopicsButtonHidden()
                viewModel.trackECommerce()
            }, content: {
                EditTopicsView(
                    viewModel: viewModel.editTopicViewModel
                )
            })
            .onAppear {
                viewModel.fetchTopics()
                viewModel.fetchDisplayedTopics()
                viewModel.showAllTopicsButtonHidden()
                viewModel.trackECommerce()
            }
            .padding()
        }
    }
}
