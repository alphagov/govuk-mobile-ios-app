import SwiftUI
import UIComponents
import GOVKit

struct TopicsWidget: View {
    @StateObject var viewModel: TopicsWidgetViewModel
    @State var showingEditScreen: Bool = false
    var testErrorCase = true

    var body: some View {
        VStack {
            if testErrorCase {
//                if viewModel.fetchTopicsError {
                HStack {
                    Text(viewModel.widgetTitle)
                        .font(Font.govUK.title3Semibold)
                        .foregroundColor(Color(UIColor.govUK.text.primary))
                    Spacer()
                }
                VStack {
                    VStack {
                        Image(systemName: "exclamationmark.circle")
                            .foregroundColor(
                                Color(
                                    UIColor.govUK.text.iconTertiary
                                )
                            )
                            .font(.title)
                        Text("error title")
                        Text(viewModel.errorDescription)
                        Text("link")
                            .onTapGesture {

                            }
                    }
                    .padding()
                }
                .background(Color(UIColor.govUK.fills.surfaceList))
                    .roundedBorder(borderColor: .clear)
            } else {
                HStack {
                    Text(viewModel.widgetTitle)
                        .font(Font.govUK.title3Semibold)
                        .foregroundColor(Color(UIColor.govUK.text.primary))
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
                VStack {
                    VStack {
                        Picker(
                            selection: $viewModel.topicsScreen,
                            label: Text("Topics view")) {
                                Text("Your topics")
                                    .foregroundColor(
                                        Color(
                                            UIColor.govUK.text.primary
                                        )
                                    )
                                    .tag(0)
                                Text("All topics")
                                    .foregroundColor(
                                        Color(
                                            UIColor.govUK.text.primary
                                        )
                                    )
                                    .tag(1)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.top)
                        if  viewModel.topicsScreen == 0 {
                            switch viewModel.isThereFavouritedTopics {
                            case true:
                                yourTopicsView
                                    .transition(
                                        AnyTransition.move(
                                            edge: .leading
                                        )
                                    )
                            case false:
                                Button {
                                    showingEditScreen.toggle()
                                } label: {
                                    VStack {
                                        Spacer()
                                        Image(systemName: "plus.circle")
                                            .foregroundColor(
                                                Color(
                                                    UIColor.govUK.text.iconTertiary
                                                )
                                            )
                                            .padding(.bottom, 6)
                                            .font(.title)
                                        Spacer()
                                        Text("Add your topics")
                                            .multilineTextAlignment(.center)
                                            .font(Font.govUK.body)
                                            .foregroundColor(
                                                Color(UIColor.govUK.text.primary))
                                    }.padding(.vertical, 20)
                                }
                            }
                        }

                        if viewModel.topicsScreen == 1 {
                            allTopicsView
                                .transition(
                                    AnyTransition.move(
                                        edge: .leading
                                    )
                                )
                        }
                    }.padding([.horizontal, .bottom])
                        .padding(.top, 4)
                }
                .background(Color(UIColor.govUK.fills.surfaceList))
                .roundedBorder(borderColor: .clear)
            }
        }.padding()
            .onAppear {
                viewModel.fetchTopics()
                viewModel.fetchDisplayedTopics()
                viewModel.fetchAllTopics()
                // viewModel.trackECommerce()
                viewModel.setTopicsScreen()
            }
            .sheet(isPresented: $showingEditScreen,
                   onDismiss: {
                viewModel.fetchAllTopics()
                viewModel.fetchTopics()
                viewModel.fetchDisplayedTopics()
                if !self.viewModel.initialLoadComplete {
                    self.viewModel.initialLoadComplete = true
                    //    self.viewModel.trackECommerce()
                }
            }, content: {
                    EditTopicsView(
                        viewModel: viewModel.editTopicViewModel
                    )
            })
    }

    var yourTopicsView: some View {
        ForEach(Array(viewModel.topicsToBeDisplayed.enumerated()), id: \.offset) { index, topic in
            VStack {
                TopicListItemView(
                    viewModel: .init(
                        title: topic.title,
                        tapAction: { viewModel.topicAction(topic) },
                        iconName: topic.iconName
                    )
                )
                if viewModel.topicsToBeDisplayed.count > 1
                    &&  index != viewModel.topicsToBeDisplayed.count - 1 {
                    Divider()
                        .padding(.leading, 70)
                        .padding(.trailing, 20)
                }
            }
        }
    }

    var allTopicsView: some View {
        ForEach(Array(viewModel.allTopics.enumerated()), id: \.offset) { index, topic in
            VStack {
                TopicListItemView(
                    viewModel: .init(
                        title: topic.title,
                        tapAction: { viewModel.topicAction(topic) },
                        iconName: topic.iconName
                    )
                )
                if index != viewModel.allTopics.count - 1 {
                    Divider()
                        .padding(.leading, 70)
                        .padding(.trailing, 20)
                }
            }
        }
    }
}
