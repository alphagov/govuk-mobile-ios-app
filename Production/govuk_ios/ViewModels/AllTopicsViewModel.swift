import UIKit
import Foundation

class AllTopicsViewModel {
    let topicsService: TopicsServiceInterface
    let analyticsService: AnalyticsServiceInterface
    let topicAction: ((Topic) -> Void)?
    var topics = [Topic]()
    var downloadError: TopicsListError?

    init(topicsService: TopicsServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         topicAction: @escaping (Topic) -> Void) {
        self.topicsService = topicsService
        self.analyticsService = analyticsService
        self.topicAction = topicAction
        fetchAllTopics {}
    }

    func fetchAllTopics(completion: @escaping () -> Void) {
        topicsService.downloadTopicsList { result in
            if case .failure(let error) = result {
                self.downloadError = error
            } else {
                self.topics = self.topicsService.fetchAllTopics()
                completion()
            }
        }
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
