import SwiftUI
import UIComponents

struct TopicsViewSwiftUI: View {
    @StateObject var viewModel: TopicsWidgetViewModelSwiftUI
    @ScaledMetric var scale: CGFloat = 1
    @State private var showingEditScreen: Bool = false
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
                    Button {
                        showingEditScreen.toggle()
                    } label: {
                        Text("edit")
                    }

//                    SwiftUIButton(.secondary, viewModel: viewModel.editButtonViewModel)
//                        .frame(width: 70 * scale)
//                        .padding([.leading], 40)
                }
                LazyVGrid(columns: columns, alignment: .center) {
                    ForEach(viewModel.topicsToBeDisplayed, id: \.self) { topic in
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
            if !viewModel.showAllTopicsButton {
                HStack {
                    Spacer()

                    Button {
                        print("pressed")
                    } label: {
                        Text("SIGN UP")
                            .frame(idealWidth: 30)
                            .font(Font.govUK.body)
                            .padding()
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    }.background(Color.yellow) // If you have this
                    .cornerRadius(25)
//                    Button(action: {
//                        print("sign up bin tapped")
//                    } {
//                        Text("SIGN UP")
//                            .frame(minWidth: 0, maxWidth: .infinity)
//                            .font(.system(size: 18))
//                            .padding()
//                            .foregroundColor(.white)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 25)
//                                    .stroke(Color.white, lineWidth: 2)
//                            )
//                    }
//                    .background(Color.yellow) // If you have this
//                    .cornerRadius(25)
                    Spacer()
                }
            }
        }.sheet(isPresented: $showingEditScreen,
                onDismiss: {
            viewModel.fetchTopics()
            viewModel.fetchDisplayedTopics()
            viewModel.showAllTopicsButtonHidden()
        },
                content: {
            EditTopicsView(
                viewModel: viewModel.editTopicViewModel
            )
        })
        .onAppear {
            viewModel.fetchTopics()
            viewModel.fetchDisplayedTopics()
            viewModel.showAllTopicsButtonHidden()
        }
        .padding()
    }
}
