import Foundation
import UIKit
import CoreData
import GOVKit

final class TopicsWidgetViewModel {
    private let topicsService: TopicsServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    let urlOpener: URLOpener
    let allTopicsAction: () -> Void
    let topicAction: (Topic) -> Void
    let editAction: () -> Void
    var handleError: ((TopicsServiceError) -> Void)?
    var fetchTopicsError: Bool = false
    var initialLoadComplete: Bool = false
    var isEditing: Bool = false

    init(topicsService: TopicsServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         urlOpener: URLOpener = UIApplication.shared,
         topicAction: @escaping (Topic) -> Void,
         editAction: @escaping () -> Void,
         allTopicsAction: @escaping () -> Void) {
        self.topicsService = topicsService
        self.analyticsService = analyticsService
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

    func trackECommerce() {
        if !isEditing && initialLoadComplete {
            let trackedTopics = displayedTopics
            var items = [HomeCommerceItem]()
            trackedTopics.enumerated().forEach { index, topic in
                let item = HomeCommerceItem(name: topic.title,
                                            index: index + 1,
                                            itemId: nil,
                                            locationId: nil)
                items.append(item)
            }
            let event = AppEvent.viewItemList(name: "Homepage",
                                              id: "Homepage",
                                              items: items)
            analyticsService.track(event: event)
        }
    }

    func trackECommerceSelection(_ name: String) {
        let trackedTopics = displayedTopics
        guard let topic = trackedTopics.first(where: {$0.title == name}),
              let index = trackedTopics.firstIndex(of: topic) else {
            return
        }
        let items = [HomeCommerceItem(name: topic.title,
                                      index: index + 1,
                                      itemId: nil,
                                      locationId: nil)]

        let event = AppEvent.selectHomePageItem(
            results: trackedTopics.count,
            items: items)
        analyticsService.track(event: event)
    }
}
