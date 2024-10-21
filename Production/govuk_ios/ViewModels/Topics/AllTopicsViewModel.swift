import UIKit
import Foundation

class AllTopicsViewModel {
    private let analyticsService: AnalyticsServiceInterface
    let topicAction: (Topic) -> Void
    var topics: [Topic] = []

    init(analyticsService: AnalyticsServiceInterface,
         topicAction: @escaping (Topic) -> Void,
         topicsService: TopicsServiceInterface) {
        self.analyticsService = analyticsService
        self.topicAction = topicAction
        self.topics = topicsService.fetchAllTopics()
    }

    func trackTopicAction(_ topic: Topic) {
        let event = AppEvent.buttonNavigation(
            text: topic.ref,
            external: false
        )
        analyticsService.track(event: event)
    }
}
