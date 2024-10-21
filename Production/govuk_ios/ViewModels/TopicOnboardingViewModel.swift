import Foundation
import UIComponents

class TopicOnboardingViewModel: ObservableObject {
    let analyticsService: AnalyticsServiceInterface
    let topicsService: TopicsServiceInterface
    let dismissAction: () -> Void
    @Published var isTopicSelected: Bool = false
    var selectedTopics: [String: Topic] = [:]

    var widgets: [WidgetView] {
        [topicsWidget]
    }

    func selectTopic(topic: Topic) {
        if let topic = selectedTopics[topic.title] {
            selectedTopics.removeValue(forKey: topic.title)
        } else {
            selectedTopics[topic.title] = topic
        }
        determineIfThereAreSelectedItems()
    }

    private func determineIfThereAreSelectedItems() {
        // change name of this method
        if !selectedTopics.isEmpty {
            isTopicSelected = true
        } else {
            isTopicSelected = false
        }
    }

    init(analyticsService: AnalyticsServiceInterface,
         topicsService: TopicsServiceInterface,
         dismissAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.topicsService = topicsService
        self.dismissAction = dismissAction
    }

    private var topicsWidget: WidgetView {
        let topicWidgetViewModel = TopicsWidgetViewModel(
            topicsService: topicsService,
            analyticsService: analyticsService,
            topicAction: { [weak self] topic in
                self?.selectTopic(topic: topic)
            },
            editAction: nil
        )

        let content = TopicsOnboardingWidgetView(
            viewModel: topicWidgetViewModel
        )
        let widget = WidgetView(decorateView: false)
        widget.addContent(content)
        return widget
    }

    var secondaryButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: "Skip",
            action: { [weak self] in
                self?.skipAction()
            }
        )
    }

    var primaryButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: "Done",
            action: { [weak self] in
                guard let self = self else { return }
                self.saveFavouriteTopics()
                self.finishSelectionAction()
            }
        )
    }

    private var selectableTopicsWidget: WidgetView? {
        let topicWidgetviewModel = TopicsWidgetViewModel(
            topicsService: topicsService,
            analyticsService: analyticsService,
            topicAction: { [weak self] topic in
                self?.selectTopic(topic: topic)
                // topic.isFavorite = true
            },
            editAction: nil)


        let content = TopicsOnboardingWidgetView(
            viewModel: topicWidgetviewModel
        )
        let widget = WidgetView(decorateView: false)
        widget.addContent(content)
        return widget
    }

    private func skipAction() {
        self.dismissAction()
    }

    private func finishSelectionAction() {
        self.dismissAction()
    }

    func saveTopicsToFavourite() {
        for (_, value) in selectedTopics {
            value.isFavorite = true
        }
    }

    private func saveFavouriteTopics() {
        saveTopicsToFavourite()
        topicsService.updateFavoriteTopics()
    }
}
