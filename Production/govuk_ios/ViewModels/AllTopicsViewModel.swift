import UIKit
import Foundation

class AllTopicsViewModel {
    let topicsService: TopicsServiceInterface
    let analyticsService: AnalyticsServiceInterface
    let topicAction: ((Topic) -> Void)?
    let topics: [Topic]
    var downloadError: TopicsListError?

    init(topicsService: TopicsServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         topicAction: @escaping (Topic) -> Void,
         topics: [Topic]) {
        self.topicsService = topicsService
        self.analyticsService = analyticsService
        self.topicAction = topicAction
        self.topics = topics
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
}
