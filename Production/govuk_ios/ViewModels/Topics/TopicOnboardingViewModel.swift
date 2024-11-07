import Foundation
import UIComponents

class TopicOnboardingViewModel: ObservableObject {
    private let analyticsService: AnalyticsServiceInterface
    private let topicsService: TopicsServiceInterface
    private let dismissAction: () -> Void
    @Published var isTopicSelected: Bool = false
    private var selectedTopics: Set<Topic> = []

    let title = String.topics.localized(
        "topicOnboardingPageTitle"
    )

    let subtitle = String.topics.localized(
        "topicOnboardingPageSubtitle"
    )

    private let primaryButtonTitle = String.topics.localized(
        "topicOnboardingPrimaryButtonTitle"
    )

    private let secondaryButtonTitle = String.topics.localized(
        "topicOnboardingSecondaryButtonTitle"
    )

    init(analyticsService: AnalyticsServiceInterface,
         topicsService: TopicsServiceInterface,
         dismissAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.topicsService = topicsService
        self.dismissAction = dismissAction
        self.fetchTopics()
    }

    var topics: [Topic] {
        topicsService.fetchAll()
    }

    private func fetchTopics() {
        topicsService.fetchRemoteList(completion: { _ in /*Do nothing*/ })
    }

    func topicSelected(topic: Topic,
                       selected: Bool) {
        let action: String
        if selected {
            action = "add"
            selectedTopics.insert(topic)
        } else {
            action = "remove"
            selectedTopics.remove(topic)
        }
        trackTopicSelection(
            title: topic.title,
            action: action
        )
        setIsTopicSelected()
    }

    private func trackTopicSelection(title: String,
                                     action: String) {
        let event = AppEvent.function(
            text: title,
            type: "buttons",
            section: "Topic selection",
            action: action
        )
        analyticsService.track(event: event)
    }

    private func setIsTopicSelected() {
        isTopicSelected = !selectedTopics.isEmpty
    }

    var secondaryButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: secondaryButtonTitle,
            action: { [weak self] in
                self?.secondaryAction()
            }
        )
    }

    var primaryButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: primaryButtonTitle,
            action: { [weak self] in
                self?.primaryAction()
            }
        )
    }

    private func primaryAction() {
        saveFavouriteTopics()
        trackPrimaryEvent()
        topicsService.setHasPersonalisedTopics()
        dismissAction()
    }

    private func secondaryAction() {
        trackSecondaryEvent()
        dismissAction()
    }

    private func saveFavouriteTopics() {
        selectedTopics.forEach { $0.isFavorite = true }
        topicsService.save()
    }

    private func trackPrimaryEvent() {
        let event = AppEvent.buttonNavigation(
            text: "Done",
            external: false
        )
        analyticsService.track(event: event)
    }

    private func trackSecondaryEvent() {
        let event = AppEvent.buttonNavigation(
            text: "Skip",
            external: false
        )
        analyticsService.track(event: event)
    }
}
