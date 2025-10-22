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
                        Text(viewModel.widgetTitle)
                            .font(Font.govUK.title3Semibold)
                            .foregroundColor(Color(UIColor.govUK.text.primary))
                        Spacer()
                    }
                    VStack {
                        VStack(spacing: 8) {
                            Image(systemName: "exclamationmark.circle")
                                .foregroundColor(Color(UIColor.govUK.text.iconTertiary))
                                .font(.title)
                            Text(viewModel.errorTitle)
                                .foregroundColor(
                                    Color(uiColor: UIColor.govUK.text.primary))
                                .font(Font.govUK.bodySemibold)
                            Text(viewModel.errorDescription)
                                .foregroundColor(
                                    Color(uiColor: UIColor.govUK.text.primary))
                                .font(Font.govUK.body)
                                .multilineTextAlignment(.center)
                            Button(
                                action: {viewModel.openErrorURL()},
                                label: {
                                    Text(viewModel.errorLink)
                                        .foregroundColor(
                                            Color(
                                                uiColor: UIColor.govUK.text.buttonSecondary
                                            )
                                        )
                                        .font(Font.govUK.body)
                                }
                            )
                            .padding(.top)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 22)
                    }
                    .background(Color(UIColor.govUK.fills.surfaceList))
                    .roundedBorder(borderColor: .clear)
                }
            } else {
                titleView
                VStack {
                    VStack {
                        Picker(
                            selection: $viewModel.topicsScreen,
                            label: Text(viewModel.widgetTitle)) {
                                Text(viewModel.personalisedTopicsPickerTitle)
                                    .foregroundColor(
                                        Color(UIColor.govUK.text.primary)
                                    )
                                    .tag(0)
                                Text(viewModel.allTopicsPickerTitle)
                                    .foregroundColor(
                                        Color(UIColor.govUK.text.primary)
                                    )
                                    .tag(1)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.top)
                        if viewModel.topicsScreen == 0 {
                            switch viewModel.hasFavouritedTopics {
                            case true:
                                yourTopicsView
                                    .transition(
                                        AnyTransition.move(
                                            edge: .leading
                                        )
                                    )
                            case false:
                                emptyStateView
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
                    }
                    .padding([.horizontal, .bottom])
                    .padding(.top, 4)
                }
                .background(Color(UIColor.govUK.fills.surfaceList))
                .roundedBorder(borderColor: .clear)
            }
        }
        .padding()
        .onAppear {
            viewModel.fetchTopics()
            viewModel.fetchDisplayedTopics()
            viewModel.fetchAllTopics()
            viewModel.setTopicsScreen()
        }
        .sheet(isPresented: $showingEditScreen,
               onDismiss: {
            viewModel.fetchAllTopics()
            viewModel.fetchTopics()
            viewModel.fetchDisplayedTopics()
            viewModel.setTopicsScreen()
        }, content: {
            NavigationView {
                EditTopicsView(
                    viewModel: viewModel.editTopicViewModel
                )
            }
        })
    }

    var allTopicsView: some View {
        ForEach(Array(viewModel.allTopics.enumerated()),
                id: \.offset) { index, topic in
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
                        .overlay(Color(UIColor.govUK.strokes.listDivider))
                        .padding(.leading, 70)
                        .padding(.trailing, 20)
                }
            }
        }
    }

    var yourTopicsView: some View {
        ForEach(Array(viewModel.topicsToBeDisplayed.enumerated()),
                id: \.offset
        ) { index, topic in
            VStack {
                TopicListItemView(
                    viewModel: .init(
                        title: topic.title,
                        tapAction: { viewModel.topicAction(topic) },
                        iconName: topic.iconName
                    )
                )
                if viewModel.topicsToBeDisplayed.count > 1
                    && index != viewModel.topicsToBeDisplayed.count - 1 {
                    Divider()
                        .overlay(Color(UIColor.govUK.strokes.listDivider))
                        .padding(.leading, 70)
                        .padding(.trailing, 20)
                }
            }
        }
    }

    var emptyStateView: some View {
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
                Text(viewModel.emptyStateTitle)
                    .multilineTextAlignment(.center)
                    .font(Font.govUK.body)
                    .foregroundColor(
                        Color(
                            UIColor.govUK.text.primary
                        )
                    )
            }
            .padding(.vertical, 14)
        }
    }

    var titleView: some View {
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
    }
}
