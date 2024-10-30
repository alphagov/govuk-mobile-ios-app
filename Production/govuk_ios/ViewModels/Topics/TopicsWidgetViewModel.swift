import Foundation
import CoreData

final class TopicsWidgetViewModel {
    private let topicsService: TopicsServiceInterface
    let allTopicsAction: () -> Void
    let topicAction: (Topic) -> Void
    let editAction: () -> Void

    private(set) var downloadError: TopicsServiceError?

    var favoriteTopics: [Topic] {
        topicsService.fetchFavorites()
    }

    var allTopicsButtonHidden: Bool {
        topicsService.fetchAll().count == favoriteTopics.count
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
        topicsService.fetchRemoteList { result in
            if case .failure(let error) = result {
                self.downloadError = error
            }
        }
    }
}
