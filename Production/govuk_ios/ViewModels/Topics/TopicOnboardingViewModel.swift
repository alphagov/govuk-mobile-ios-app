import Foundation
import UIComponents

class TopicOnboardingViewModel: ObservableObject {
    let topics: [Topic]
    private let analyticsService: AnalyticsServiceInterface
    private let topicsService: TopicsServiceInterface
    private let dismissAction: () -> Void
    @Published private(set) var isTopicSelected: Bool = false
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

    init(topics: [Topic],
         analyticsService: AnalyticsServiceInterface,
         topicsService: TopicsServiceInterface,
         dismissAction: @escaping () -> Void) {
        self.topics = topics
        self.analyticsService = analyticsService
        self.topicsService = topicsService
        self.dismissAction = dismissAction
    }

    func topicSelected(topic: Topic) {
        topic.isFavourite.toggle()
        let action: String
        if topic.isFavourite {
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
        let event = AppEvent.buttonFunction(
            text: title,
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
        topicsService.setHasCustomisedTopics()
        dismissAction()
    }

    private func secondaryAction() {
        topics.first?.managedObjectContext?.rollback()
        trackSecondaryEvent()
        dismissAction()
    }

    private func saveFavouriteTopics() {
        selectedTopics.forEach { $0.isFavourite = true }
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
