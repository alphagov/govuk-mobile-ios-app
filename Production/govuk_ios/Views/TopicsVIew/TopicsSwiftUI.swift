import SwiftUI

struct TopicCardSwiftUi: View {
    let viewModel: TopicsWidgetViewModel
    private let columns = [
        GridItem(.flexible(), spacing: 2, alignment: .leading),
        GridItem(.flexible(), spacing: 2, alignment: .leading)
    ]

    var body: some View {
        VStack {
            HStack {
                Text(viewModel.widgetTitle)
                Spacer()
                Button {
                    viewModel.editAction()
                } label: {
                    Text(String.common.localized("editButtonTitle"))
                }
            }
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center) {
                    ForEach(viewModel.displayedTopics, id: \.self) { topic in
                        TopicCardSwiftUI(model: topic)
                            .background(Color(uiColor: UIColor.govUK.fills.surfaceCardBlue))
                            .roundedBorder(
                                cornerRadius: 10,
                                borderColor: Color(uiColor: UIColor.govUK.strokes.cardBlue),
                                borderWidth: 1
                            ).padding(2)
                            .onTapGesture {
                                viewModel.topicAction(topic)
                            }
                    }
                }
            }
        }
        .padding()
    }
}
