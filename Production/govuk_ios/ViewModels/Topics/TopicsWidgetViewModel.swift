import Foundation
import CoreData

final class TopicsWidgetViewModel {
    private let analyticsService: AnalyticsServiceInterface
    private let topicsService: TopicsServiceInterface
    private let topicAction: ((Topic) -> Void)?
    private let editAction: (([Topic]) -> Void)?

    var downloadError: TopicsListError?

    var favoriteTopics: [Topic] {
        topicsService.fetchFavoriteTopics()
    }

    init(topicsService: TopicsServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         topicAction: ((Topic) -> Void)?,
         editAction: (([Topic]) -> Void)?) {
        self.topicsService = topicsService
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

    func didTapTopic(_ topic: Topic) {
        guard let action = topicAction else { return }
        let event = AppEvent.widgetNavigation(
            text: topic.ref
        )
        analyticsService.track(event: event)
        action(topic)
    }

    @objc
    func didTapEdit() {
        guard let action = editAction else { return }
        let topics = topicsService.fetchAllTopics()
        let event = AppEvent.widgetNavigation(
            text: "EditTopics"
        )
        analyticsService.track(event: event)
        action(topics)
    }
}
