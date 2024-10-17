import UIKit
import Foundation

class AllTopicsViewModel {
    let analyticsService: AnalyticsServiceInterface
    let topicAction: ((Topic) -> Void)?
    let topics: [Topic]
    var downloadError: TopicsListError?

    init(analyticsService: AnalyticsServiceInterface,
         topicAction: @escaping (Topic) -> Void,
         topics: [Topic]) {
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
