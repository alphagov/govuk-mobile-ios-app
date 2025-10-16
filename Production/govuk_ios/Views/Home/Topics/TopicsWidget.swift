import SwiftUI
import UIComponents
import GOVKit

struct TopicsWidget: View {
    @StateObject var viewModel: TopicsWidgetViewModel
    @State private var topicsView = 0

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
                            Picker(selection: $topicsView, label: Text("Authentication Path")) {
                                Text("Topics")
                                    .tag(0)
                                Text("All topics")
                                    .tag(1)
                            }.pickerStyle(SegmentedPickerStyle())
                            if topicsView == 0 {
                                withAnimation {
                                    yourTopicsView
                                        .transition(.move(edge: .leading))
                                }
                            }
                            if topicsView == 1 {
                                withAnimation {
                                    allTopicsView
                                        .transition(.move(edge: .leading))
                                }
                            }
                        }
                        .padding([.horizontal, .top])
                    }
                }
            }
        }.onAppear {
            viewModel.fetchTopics()
            viewModel.fetchDisplayedTopics()
            viewModel.fetchAllTopics()
        }
    }

        @ViewBuilder
        var yourTopicsView: some View {
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
        @ViewBuilder
        var allTopicsView: some View {
            ForEach(viewModel.allTopics, id: \.self) { topic in
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
