import SwiftUI
import UIComponents

struct TopicsViewSwiftUI: View {
    let viewModel: TopicsWidgetViewModel
    @ScaledMetric var scale: CGFloat = 1
    private let columns = [
        GridItem(.flexible(), spacing: 2, alignment: .leading),
        GridItem(.flexible(), spacing: 2, alignment: .leading)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            ScrollView {
                HStack {
                    Text(viewModel.widgetTitle)
                        .font(Font.govUK.title3Semibold)
                        .padding([.leading], 4)
                    Spacer()
                    SwiftUIButton(.secondary, viewModel: viewModel.editButtonViewModel)
                        .frame(width: 70 * scale)
                        .padding([.leading], 40)
                }
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
