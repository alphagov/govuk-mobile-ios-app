import SwiftUI
import UIComponents
import GOVKit

struct TopicsWidget: View {
    @StateObject var viewModel: TopicsWidgetViewModel
    @State var showingEditScreen: Bool = false

    var body: some View {
        VStack {
            if viewModel.fetchTopicsError {
                VStack {
                    HStack {
                        Text( String.home.localized("topicsWidgetTitleCustomised")
                        )
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
                                    Text("error")
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
            NavigationView {
                EditTopicsView(
                    viewModel: viewModel.editTopicViewModel
                )
            }
        })
    }

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
