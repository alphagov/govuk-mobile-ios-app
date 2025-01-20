import UIKit
import Foundation
import GOVKit

class AllTopicsViewModel {
    let analyticsService: AnalyticsServiceInterface
    let topicAction: (Topic) -> Void
    private(set) var topics: [Topic] = []

    init(analyticsService: AnalyticsServiceInterface,
         topicAction: @escaping (Topic) -> Void,
         topicsService: TopicsServiceInterface) {
        self.analyticsService = analyticsService
        self.topicAction = topicAction
        self.topics = topicsService.fetchAll()
    }

    func trackTopicAction(_ topic: Topic) {
        let event = AppEvent.buttonNavigation(
            text: topic.ref,
            external: false
        )
        analyticsService.track(event: event)
    }
}
