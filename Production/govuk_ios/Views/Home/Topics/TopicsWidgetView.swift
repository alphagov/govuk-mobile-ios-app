import SwiftUI
import UIComponents
import GOVKit

struct TopicsWidgetView: View {
    @StateObject var viewModel: TopicsWidgetViewModel
    @State var showingEditScreen: Bool = false

    var body: some View {
        VStack {
            SectionHeaderLabelView(
                model: SectionHeaderLabelViewModel(
                    title: viewModel.widgetTitle,
                    button: .init(
                        localisedTitle: viewModel.editButtonTitle,
                        localisedAccessibilityLabel: viewModel.editButtonAccessibilityLabel,
                        action: { showingEditScreen.toggle() })
                )
            )
            .opacity(viewModel.fetchTopicsError ? 0 : 1)
            .padding(.top, 16)
            if viewModel.fetchTopicsError {
                AppErrorView(viewModel: viewModel.errorViewModel)
                    .padding(.vertical)
                    .background(Color(UIColor.govUK.fills.surfaceList))
                    .roundedBorder(borderColor: .clear)
            } else {
                VStack(spacing: 0) {
                    topicPicker
                    switch viewModel.topicsScreen {
                    case .favourite:
                        if viewModel.hasFavouritedTopics {
                            topicsListViewFor(topics: viewModel.favouriteTopics)
                        } else {
                            emptyStateView
                        }
                    case .all:
                        topicsListViewFor(topics: viewModel.allTopics)
                    }
                }
                .padding(.top, 16)
                .background(Color(UIColor.govUK.fills.surfaceList))
                .roundedBorder(borderColor: .clear)
            }
        }
        .padding()
        .onAppear {
            viewModel.refreshTopics()
            viewModel.initialLoadComplete = true
        }
        .sheet(isPresented: $showingEditScreen,
               onDismiss: {
            viewModel.refreshTopics()
            viewModel.didDismissEdit()
        }, content: {
            NavigationView {
                EditTopicsView(
                    viewModel: viewModel.editTopicViewModel
                )
            }
        })
    }

    private var topicPicker: some View {
        Picker(
            selection: $viewModel.topicsScreen,
            label: Text(viewModel.widgetTitle)) {
                Text(viewModel.personalisedTopicsPickerTitle)
                    .foregroundColor(
                        Color(UIColor.govUK.text.primary)
                    ).tag(TopicSegment.favourite)
                Text(viewModel.allTopicsPickerTitle)
                    .foregroundColor(
                        Color(UIColor.govUK.text.primary)
                    ).tag(TopicSegment.all)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 16)
    }

    func topicsListViewFor(topics: [Topic]) -> some View {
        ForEach(Array(topics.enumerated()),
                id: \.offset
        ) { index, topic in
            VStack(spacing: 0) {
                TopicListItemView(
                    viewModel: .init(
                        title: topic.title,
                        tapAction: {
                            viewModel.topicAction(topic)
                            viewModel.trackECommerceSelection(topic.title)
                        },
                        iconName: topic.iconName
                    )
                )
                if index < topics.count - 1 {
                    Divider()
                        .overlay(Color(UIColor.govUK.strokes.listDivider))
                        .padding(.leading, 70)
                        .padding(.trailing, 20)
                }
            }
        }
        .transition(
            AnyTransition.move(
                edge: .leading
            )
        )
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
}
