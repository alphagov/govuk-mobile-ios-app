import Foundation
import CoreData

final class TopicsWidgetViewModel {
    private let topicsService: TopicsServiceInterface
    let allTopicsAction: () -> Void
    let topicAction: (Topic) -> Void
    let editAction: () -> Void

    private(set) var downloadError: TopicsListError?

    var favoriteTopics: [Topic] {
        topicsService.fetchFavoriteTopics()
    }
    var allTopicsButtonHidden: Bool {
        topicsService.fetchAllTopics().count == favoriteTopics.count
    }

    init(topicsService: TopicsServiceInterface,
         topicAction: @escaping (Topic) -> Void,
         editAction: @escaping () -> Void,
         allTopicsAction: @escaping () -> Void) {
        self.topicsService = topicsService
        self.topicAction = topicAction
        self.editAction = editAction
        self.allTopicsAction = allTopicsAction
        self.fetchTopics()
    }

    private func fetchTopics() {
        topicsService.downloadTopicsList { result in
            if case .failure(let error) = result {
                self.downloadError = error
            }
        }
    }
}
