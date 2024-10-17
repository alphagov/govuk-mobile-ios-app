import Foundation
import CoreData

final class TopicsWidgetViewModel {
    private let analyticsService: AnalyticsServiceInterface
    private let topicsService: TopicsServiceInterface
    private let topicAction: ((Topic) -> Void)?
    private let editAction: (([Topic]) -> Void)?
    private let allTopicsAction: (([Topic]) -> Void)?

    var downloadError: TopicsListError?

    var favoriteTopics: [Topic] {
        topicsService.fetchFavoriteTopics()
    }

    init(topicsService: TopicsServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         topicAction: ((Topic) -> Void)?,
         editAction: (([Topic]) -> Void)?,
         allTopicsAction: (([Topic]) -> Void)?) {
        self.topicsService = topicsService
        self.topicAction = topicAction
        self.editAction = editAction
        self.allTopicsAction = allTopicsAction
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
        let event = AppEvent.buttonNavigation(
            text: topic.ref,
            external: false
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

    func didTapSeeAllTopics() {
        guard let action = allTopicsAction else { return }
        let topics = topicsService.fetchAllTopics()
        let event = AppEvent.buttonNavigation(
            text: "See all Topics",
            external: false
        )
        analyticsService.track(event: event)
        action(topics)
    }
}
