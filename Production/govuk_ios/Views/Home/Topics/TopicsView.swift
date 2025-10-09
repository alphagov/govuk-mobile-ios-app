import SwiftUI
import UIComponents
import GOVKit

struct TopicsView: View {
    @StateObject var viewModel: TopicsWidgetViewModel
    @State var showingEditScreen: Bool = false
    @Environment(\.defaultMinListRowHeight) var minRowHeight

    var body: some View {
        if viewModel.fetchTopicsError {
            VStack {
                Text("error")
            }.padding()
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
                                    .foregroundColor(Color(UIColor.govUK.text.link))
                                    .font(Font.govUK.subheadlineSemibold)
                            }
                        )
                    }
                }.padding(.horizontal)
                VStack(spacing: 0) {
                ForEach(viewModel.topicsToBeDisplayed, id: \.self) { topic in
                    TopicCard(model: topic, isLastInList: <#Bool#>, )
                        .background(Color(uiColor: UIColor.govUK.fills.surfaceCardBlue))
                        .onTapGesture {
                            viewModel.trackECommerceSelection(topic.title)
                            viewModel.topicAction(topic)
                        }
                }
            }
            }.sheet(isPresented: $showingEditScreen,
                    onDismiss: {
                viewModel.fetchTopics()
                viewModel.fetchDisplayedTopics()
                viewModel.updateShowAllButtonVisibility()
                viewModel.trackECommerce()
            }, content: {
                EditTopicsView(
                    viewModel: viewModel.editTopicViewModel
                )
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
