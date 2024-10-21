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

    var allTopics: [Topic] {
        topicsService.fetchAllTopics()
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

    var getTopics: [Topic] {
        if topicsService.fetchFavoriteTopics() == [] {
            switch topicsService.editMode {
            case true:
                return topicsService.fetchFavoriteTopics()
            default:
                return topicsService.fetchAllTopics()
            }
        } else {
            return topicsService.fetchFavoriteTopics()
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
}
