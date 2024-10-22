import Foundation
import CoreData

final class TopicsWidgetViewModel {
    private let analyticsService: AnalyticsServiceInterface
    private let topicsService: TopicsServiceInterface
    private let topicAction: ((Topic) -> Void)?
    private let editAction: (([Topic]) -> Void)?
    private let userDefaults: UserDefaults

    var downloadError: TopicsListError?

    var favoriteTopics: [Topic] {
        topicsService.fetchFavoriteTopics()
    }

    var allTopics: [Topic] {
        topicsService.fetchAllTopics()
    }

    init(topicsService: TopicsServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         userDefaults: UserDefaults,
         topicAction: ((Topic) -> Void)?,
         editAction: (([Topic]) -> Void)?) {
        self.topicsService = topicsService
        self.userDefaults = userDefaults
        self.topicAction = topicAction
        self.editAction = editAction
        self.analyticsService = analyticsService
        self.fetchTopics()
    }

    func fetchTopics() {
        topicsService.downloadTopicsList { result in
            if case .failure(let error) = result {
                self.downloadError = error
            }
        }
    }

    var getTopics: [Topic] {
        if topicsService.fetchFavoriteTopics() == [] {
            switch hasTopicsBeenEdited {
            case true:
                return topicsService.fetchFavoriteTopics()
            case false:
                return topicsService.fetchAllTopics()
            }
        } else {
            return topicsService.fetchFavoriteTopics()
        }
    }

    var hasTopicsBeenEdited: Bool {
        userDefaults.bool(forKey: .hasEditedTopics)
    }

    func didTapTopic(_ topic: Topic) {
        guard let action = topicAction else { return }
        let event = AppEvent.buttonNavigation(
            text: topic.ref,
            external: false
        )
        analyticsService.track(event: event)
        action(topic)
    }

    // Verify this with andrew
    func didSelectOnboardingTopic(title: String,
                                  topic: Topic,
                                  isTopicSelected: Bool) {
        guard let action = topicAction else { return }
        let event = AppEvent.buttonFunction(
            text: title,
            section: "onboarding",
            action: isTopicSelected == true ? "select" : "deselect"
        )
        analyticsService.track(event: event)
        action(topic)
    }

    @objc
    func didTapEdit() {
        guard let action = editAction else { return }
        let topics = topicsService.fetchAllTopics()
        let event = AppEvent.buttonNavigation(
            text: "EditTopics",
            external: false
        )
        analyticsService.track(event: event)
        action(topics)
    }
}
