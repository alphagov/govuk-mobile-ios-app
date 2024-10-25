import Foundation
import CoreData

final class TopicsOnboardingWidgetViewModel {
    private let analyticsService: AnalyticsServiceInterface
    private let topicsService: TopicsServiceInterface
    private let topicAction: ((Topic) -> Void)?
    private let userDefaults: UserDefaults
    private(set) var downloadError: TopicsServiceError?

    var allTopics: [Topic] {
        topicsService.fetchAllTopics()
    }

    init(topicsService: TopicsServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         userDefaults: UserDefaults,
         topicAction: ((Topic) -> Void)?) {
        self.topicsService = topicsService
        self.userDefaults = userDefaults
        self.topicAction = topicAction
        self.analyticsService = analyticsService
        self.fetchTopics()
    }

    private func fetchTopics() {
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
            default:
                return topicsService.fetchAllTopics()
            }
        } else {
            return topicsService.fetchFavoriteTopics()
        }
    }

    private var hasTopicsBeenEdited: Bool {
        userDefaults.bool(forKey: .hasEditedTopics)
    }

    func selectOnboardingTopic(topic: Topic,
                               isTopicSelected: Bool) {
        guard let action = topicAction else { return }
        let event = AppEvent.function(
            text: topic.title,
            type: "buttons",
            section: "topic selection",
            action: isTopicSelected == true ? "add" : "remove"
        )
        analyticsService.track(event: event)
        action(topic)
    }
}
