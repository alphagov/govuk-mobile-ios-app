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
        displayedTopics.count >= topicsService.fetchAll().count
    }

    var widgetTitle: String {
        let key = self.topicsService.hasCustomisedTopics ?
        "topicsWidgetTitleCustomised" :
        "topicsWidgetTitle"
        return String.home.localized(key)
    }

    var displayedTopics: [Topic] {
        topicsService.hasCustomisedTopics ?
        topicsService.fetchFavourites() :
        topicsService.fetchAll()
    }

    var topicCount: Int {
        topicsService.fetchAll().count
    }

    private func fetchTopics() {
        topicsService.fetchRemoteList { result in
            if case .failure(let error) = result {
                self.downloadError = error
            }
        }
    }
}
