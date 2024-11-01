import Foundation
import CoreData

final class TopicsOnboardingListViewModel {
    private let analyticsService: AnalyticsServiceInterface
    private let topicsService: TopicsServiceInterface
    private let topicAction: (Topic) -> Void

    var allTopics: [Topic] {
        topicsService.fetchAllTopics()
    }

    init(topicsService: TopicsServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         topicAction: @escaping (Topic) -> Void) {
        self.topicsService = topicsService
        self.topicAction = topicAction
        self.analyticsService = analyticsService
        self.fetchTopics()
    }

    private func fetchTopics() {
        topicsService.downloadTopicsList { _ in }
    }

    func selectOnboardingTopic(topic: Topic,
                               isTopicSelected: Bool) {
        let event = AppEvent.function(
            text: topic.title,
            type: "buttons",
            section: "topic selection",
            action: isTopicSelected ? "add" : "remove"
        )
        analyticsService.track(event: event)
        topicAction(topic)
    }
}
