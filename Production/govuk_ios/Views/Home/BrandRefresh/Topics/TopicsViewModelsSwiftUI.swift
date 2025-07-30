import Foundation
import UIKit
import CoreData
import GOVKit
import UIComponents


final class TopicsWidgetViewModelSwiftUI: ObservableObject {
    private let topicsService: TopicsServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    let urlOpener: URLOpener
    let allTopicsAction: () -> Void
    let topicAction: (Topic) -> Void
    var handleError: ((TopicsServiceError) -> Void)?
    var fetchTopicsError: Bool = false
    var initialLoadComplete: Bool = false
    var isEditing: Bool = false
    @Published var error = false
    @Published var showAllTopicsButton = false
    @Published var topicsToBeDisplayed: [Topic] = []
    var editTopicViewModel: EditTopicsViewModel

    init(topicsService: TopicsServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         urlOpener: URLOpener = UIApplication.shared,
         topicAction: @escaping (Topic) -> Void,
         allTopicsAction: @escaping () -> Void) {
        self.topicsService = topicsService
        self.analyticsService = analyticsService
        self.urlOpener = urlOpener
        self.topicAction = topicAction
        self.allTopicsAction = allTopicsAction
        self.editTopicViewModel = EditTopicsViewModel(
            topicsService: topicsService,
            analyticsService: analyticsService
        )
    }

    func showAllTopicsButtonHidden() {
        showAllTopicsButton =
        (topicsToBeDisplayed.count >= topicsService.fetchAll().count) ||
        fetchTopicsError
    }

    var widgetTitle: String {
        let key = self.topicsService.hasCustomisedTopics ?
        "topicsWidgetTitleCustomised" :
        "topicsWidgetTitle"
        return String.home.localized(key)
    }

    func fetchDisplayedTopics() {
        topicsToBeDisplayed =
        topicsService.hasCustomisedTopics ?
        topicsService.fetchFavourites() :
        topicsService.fetchAll()
    }

    func trackECommerce() {
        if !isEditing && initialLoadComplete {
            let trackedTopics = topicsToBeDisplayed
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

    func fetchTopics() {
        topicsService.fetchRemoteList {[weak self] result in
            switch result {
            case .success(let list):
                break
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.error = true
                }
            }
        }
    }

    func trackECommerceSelection(_ name: String) {
        let trackedTopics = topicsToBeDisplayed
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
