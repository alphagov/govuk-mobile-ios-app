import Foundation
import UIKit
import CoreData
import GOVKit
import UIComponents

enum TopicSegment {
    case favourite
    case all
}

final class TopicsWidgetViewModel: ObservableObject {
    private let topicsService: TopicsServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    private let urlOpener: URLOpener
    let topicAction: (Topic) -> Void
    private let dismissEditAction: () -> Void
    @Published var fetchTopicsError = false
    @Published var favouriteTopics: [Topic] = []
    @Published var allTopics: [Topic] = []
    @Published var topicsScreen: TopicSegment = .favourite {
        didSet {
            if oldValue != topicsScreen &&
                initialLoadComplete {
                trackECommerce()
            }
        }
    }

    @Published var initialLoadComplete = false

    var errorViewModel: AppErrorViewModel {
        .topicErrorWithAction { [weak self] in
            self?.openErrorURL()
        }
    }

    let editButtonTitle = String.common.localized(
        "editButtonTitle"
    )

    let editButtonAccessibilityLabel = String.home.localized(
        "editTopicsAccessibilityLabel"
    )

    let personalisedTopicsPickerTitle = String.home.localized(
        "personalisedTopicsPickerTitle"
    )
    let allTopicsPickerTitle = String.home.localized(
        "allTopicsPickerTitle"
    )
    let emptyStateTitle = String.home.localized(
        "topicsEmptyStateTitle"
    )
    let widgetTitle = String.home.localized(
        "topicsWidgetTitle"
    )

    init(topicsService: TopicsServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         urlOpener: URLOpener = UIApplication.shared,
         topicAction: @escaping (Topic) -> Void,
         dismissEditAction: @escaping () -> Void) {
        self.topicsService = topicsService
        self.analyticsService = analyticsService
        self.urlOpener = urlOpener
        self.topicAction = topicAction
        self.dismissEditAction = dismissEditAction
    }

    lazy var editTopicViewModel: EditTopicsViewModel = {
        EditTopicsViewModel(
            topicsService: topicsService,
            analyticsService: analyticsService
        )
    }()

    var hasFavouritedTopics: Bool {
        topicsService.fetchFavourites() != []
    }

    func updateFavouriteTopics() {
        favouriteTopics = topicsService.fetchFavourites()
    }

    func updateAllTopics() {
        allTopics = topicsService.fetchAll()
    }

    @MainActor
    func refreshTopics() {
        fetchTopics()
        updateFavouriteTopics()
        updateAllTopics()
    }

    func openErrorURL() {
        urlOpener.openIfPossible(Constants.API.govukBaseUrl)
    }

    func didDismissEdit() {
        dismissEditAction()
    }

    @MainActor
    func fetchTopics() {
        topicsService.fetchRemoteList { [weak self] result in
            Task { @MainActor in
                switch result {
                case .success:
                    self?.fetchTopicsError = false
                case .failure:
                    self?.fetchTopicsError = true
                }
            }
        }
    }

    private var listName: String {
        topicsScreen == .favourite ? "Your topics" : "All topics"
    }

    func trackECommerce() {
        let trackedTopics = topicsScreen == .favourite ? favouriteTopics : allTopics
        var items = [HomeCommerceItem]()
        trackedTopics.enumerated().forEach { index, topic in
            let item = HomeCommerceItem(
                name: topic.title,
                listName: listName,
                index: index + 1,
                itemId: nil,
                locationId: nil
            )
            items.append(item)
        }
        let event = AppEvent.viewItemList(name: listName,
                                          id: listName,
                                          items: items)
        analyticsService.track(event: event)
    }

    func trackECommerceSelection(_ name: String) {
        let trackedTopics = topicsScreen == .favourite ? favouriteTopics : allTopics
        guard let topic = trackedTopics.first(where: {$0.title == name}),
              let index = trackedTopics.firstIndex(of: topic) else {
            return
        }
        let items = [HomeCommerceItem(name: topic.title,
                                      listName: listName,
                                      index: index + 1,
                                      itemId: nil,
                                      locationId: nil)]

        let event = AppEvent.selectItem(
            listName: listName,
            listId: listName,
            results: trackedTopics.count,
            items: items)
        analyticsService.track(event: event)
    }
}
