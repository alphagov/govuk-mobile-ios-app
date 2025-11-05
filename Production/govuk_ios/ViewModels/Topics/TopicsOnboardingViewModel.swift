import Foundation
import SwiftUI

import UIComponents
import GOVKit

class TopicsOnboardingViewModel: ObservableObject {
    @Published private(set) var topicSelectionCards: [TopicSelectionCardViewModel] = []
    @Published private(set) var isTopicSelected: Bool = false
    private let analyticsService: AnalyticsServiceInterface
    private let topicsService: TopicsServiceInterface
    private let dismissAction: () -> Void

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
        self.analyticsService = analyticsService
        self.topicsService = topicsService
        self.dismissAction = dismissAction
        loadTopicCards(topics: topics)
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

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }

    private func loadTopicCards(topics: [Topic]) {
        topicSelectionCards = topics.map { topic in
            topicSelectionCard(topic: topic)
        }
    }

    private func topicSelectionCard(topic: Topic) -> TopicSelectionCardViewModel {
        TopicSelectionCardViewModel(
            topic: topic,
            tapAction: { [weak self] value in
                guard let self else { return }
                topic.isFavourite = value
                isTopicSelected = topicSelectionCards.contains(where: { $0.isOn })
                trackSelection(topic: topic)
            }
        )
    }

    private func trackSelection(topic: Topic) {
        let event = AppEvent.topicSelection(
            title: topic.title,
            isFavourite: topic.isFavourite
        )
        analyticsService.track(event: event)
    }

    private func primaryAction() {
        topicsService.save()
        trackPrimaryEvent()
        dismissAction()
    }

    private func secondaryAction() {
        topicsService.rollback()
        trackSecondaryEvent()
        dismissAction()
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
