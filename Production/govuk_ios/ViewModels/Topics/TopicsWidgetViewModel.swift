import Foundation
import CoreData

final class TopicsWidgetViewModel {
    private let topicsService: TopicsServiceInterface
    let allTopicsAction: () -> Void
    let topicAction: (Topic) -> Void
    let editAction: () -> Void
    private(set) var downloadError: TopicsServiceError?

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

    var allTopicsButtonHidden: Bool {
        displayedTopics.count >= topicsService.fetchAllTopics().count
    }

    var displayedTopics: [Topic] {
        topicsService.hasTopicsBeenEdited ?
        topicsService.fetchFavoriteTopics() :
        topicsService.fetchAllTopics()
    }

    private func fetchTopics() {
        topicsService.downloadTopicsList { result in
            if case .failure(let error) = result {
                self.downloadError = error
            }
        }
    }
}
