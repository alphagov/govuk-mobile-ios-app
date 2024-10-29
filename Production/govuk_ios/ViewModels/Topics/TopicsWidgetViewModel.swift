import Foundation
import CoreData

final class TopicsWidgetViewModel {
    private let topicsService: TopicsServiceInterface
    let allTopicsAction: () -> Void
    let topicAction: (Topic) -> Void
    let editAction: () -> Void
    private let userDefaults: UserDefaults
    private(set) var downloadError: TopicsServiceError?

    var favoriteTopics: [Topic] {
        topicsService.fetchFavoriteTopics()
    }

    var allTopicsButtonHidden: Bool {
        topicsService.fetchAllTopics().count == favoriteTopics.count
    }


    var topics: [Topic] {
        if topicsService.fetchFavoriteTopics() == [] {
            if topicsService.hasTopicsBeenEdited {
                return topicsService.fetchFavoriteTopics()
            } else {
                return topicsService.fetchAllTopics()
            }
        } else {
            return topicsService.fetchFavoriteTopics()
        }
    }

    init(topicsService: TopicsServiceInterface,
         userDefaults: UserDefaults,
         topicAction: @escaping (Topic) -> Void,
         editAction: @escaping () -> Void,
         allTopicsAction: @escaping () -> Void) {
        self.topicsService = topicsService
        self.userDefaults = userDefaults
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
