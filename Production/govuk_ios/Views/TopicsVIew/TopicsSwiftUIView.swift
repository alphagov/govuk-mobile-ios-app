import SwiftUI

struct TopicsSwiftUIView: View {
    let viewModel: HomeViewModel

    let columns = [
        GridItem(.flexible(), spacing: 2, alignment: .leading),
        GridItem(.flexible(), spacing: 2, alignment: .leading)
    ]

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center) {
                    ForEach(viewModel.topicWidgetViewModel.displayedTopics, id: \.self) { topic in
                        TopicCardViewSwiftUI(model: topic)
                            .background(Color(uiColor: UIColor.govUK.fills.surfaceCardBlue))
                            .roundedBorder(
                                cornerRadius: 10,
                                borderColor: Color(uiColor: UIColor.govUK.strokes.cardBlue),
                                borderWidth: 1
                            ).padding(2)
                    }
                }
            }
        }.padding()
    }
}
