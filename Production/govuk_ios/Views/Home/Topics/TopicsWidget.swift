import SwiftUI
import UIComponents
import GOVKit

struct TopicsWidget: View {
    @StateObject var viewModel: TopicsWidgetViewModel

    var body: some View {
        VStack {
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
                    Picker(, selection: $favoriteColor) {
                        Text("Red").tag(0)
                        Text("Green").tag(1)
                        Text("Blue").tag(2)
                                            }
                        VStack(alignment: .leading) {
                            HStack {
                                Text(viewModel.widgetTitle)
                                    .font(Font.govUK.title3Semibold)
                                    .foregroundColor(Color(UIColor.govUK.text.primary))
                                Spacer()
                                Button(
                                    action: {
                                    }, label: {
                                        Text(viewModel.editButtonTitle)
                                            .foregroundColor(
                                                Color(UIColor.govUK.text.buttonSecondary)
                                            )
                                            .font(Font.govUK.subheadlineSemibold)
                                    }
                                )
                            }
                            VStack {
                                ForEach(viewModel.topicsToBeDisplayed, id: \.self) { topic in
                                    TopicListItemView(
                                        viewModel: .init(
                                            title: topic.title,
                                            tapAction: { viewModel.topicAction(topic) },
                                            iconName: topic.iconName
                                        )
                                    )
                                }
                            }
                        }
                    }
                    .padding([.horizontal, .top])
                }
            }
                .onAppear {
                    viewModel.fetchTopics()
                    viewModel.fetchDisplayedTopics()
                }
        }
    }
}
