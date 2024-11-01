import Foundation
import UIComponents
import UIKit

class TopicOnboardingViewModel: ObservableObject {
    private let analyticsService: AnalyticsServiceInterface
    private let topicsService: TopicsServiceInterface
    private let dismissAction: () -> Void
    @Published var isTopicSelected: Bool = false
    private var selectedTopics: [String: Topic] = [:]

    let title = String.topics.localized(
        "topicOnboardingPageTitle"
    )

    let subtitle = String.topics.localized(
        "topicsOnboardingPageSubtitle"
    )

    private let primaryButtonTitle = String.topics.localized(
        "topicsOnboardingPrimaryButtonTitle"
    )

    private let secondaryButtonTitle = String.topics.localized(
        "topicsOnboardingSecondaryButtonTitle"
    )

    init(analyticsService: AnalyticsServiceInterface,
         topicsService: TopicsServiceInterface,
         dismissAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.topicsService = topicsService
        self.dismissAction = dismissAction
    }

    private func selectTopic(topic: Topic) {
        if let topic = selectedTopics[topic.title] {
            selectedTopics.removeValue(forKey: topic.title)
        } else {
            selectedTopics[topic.title] = topic
        }
        setIsTopicSelected()
    }

    private func setIsTopicSelected() {
        isTopicSelected = !selectedTopics.isEmpty
    }

    var topicsWidget: UIView {
        let topicWidgetViewModel = TopicsOnboardingListViewModel(
            topicsService: topicsService,
            analyticsService: analyticsService,
            topicAction: { [weak self] topic in
                self?.selectTopic(topic: topic)
            }
        )

        return TopicsOnboardingListView(
            viewModel: topicWidgetViewModel
        )
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
        topicsService.setHasEditedTopics()
        dismissAction()
    }

    private func secondaryAction() {
        trackSecondaryEvent()
        dismissAction()
    }

    private func saveTopicsToFavourite() {
        selectedTopics.values.forEach { $0.isFavorite = true }
    }

    private func saveFavouriteTopics() {
        saveTopicsToFavourite()
        topicsService.updateFavoriteTopics()
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
