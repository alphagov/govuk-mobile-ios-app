import Foundation
import UIKit
import CoreData
import GOVKit

final class TopicsWidgetViewModel {
    private let topicsService: TopicsServiceInterface
    let urlOpener: URLOpener
    let allTopicsAction: () -> Void
    let topicAction: (Topic) -> Void
    let editAction: () -> Void
    var handleError: ((TopicsServiceError) -> Void)?
    var fetchTopicsError: Bool = false

    init(topicsService: TopicsServiceInterface,
         urlOpener: URLOpener = UIApplication.shared,
         topicAction: @escaping (Topic) -> Void,
         editAction: @escaping () -> Void,
         allTopicsAction: @escaping () -> Void) {
        self.topicsService = topicsService
        self.urlOpener = urlOpener
        self.topicAction = topicAction
        self.editAction = editAction
        self.allTopicsAction = allTopicsAction
    }

    var allTopicsButtonHidden: Bool {
        (displayedTopics.count >= topicsService.fetchAll().count) ||
        fetchTopicsError
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

    lazy var topicErrorViewModel: AppErrorViewModel = {
        AppErrorViewModel(
            title: String.common.localized("genericErrorTitle"),
            body: String.topics.localized("topicFetchErrorSubtitle"),
            buttonTitle: String.common.localized("genericErrorButtonTitle"),
            buttonAccessibilityLabel: String.common.localized(
                "genericErrorButtonTitleAccessibilityLabel"
            ),
            isWebLink: true,
            action: {
                self.urlOpener.openIfPossible(Constants.API.govukBaseUrl)
            }
        )
    }()

    func fetchTopics() {
        topicsService.fetchRemoteList { [weak self] result in
            if case .failure(let error) = result {
                self?.handleError?(error)
                self?.fetchTopicsError = true
            } else {
                self?.fetchTopicsError = false
            }
        }
    }
}
