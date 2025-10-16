import Foundation
import UIKit
import CoreData
import GOVKit
import UIComponents


final class TopicsWidgetViewModel: ObservableObject {
    private let topicsService: TopicsServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    let urlOpener: URLOpener
    let allTopicsAction: () -> Void
    let topicAction: (Topic) -> Void
    var initialLoadComplete: Bool = false
    @Published var fetchTopicsError = false
    @Published var showAllTopicsButton = false
    @Published var topicsToBeDisplayed: [Topic] = []
    @Published var allTopics: [Topic] = []
    let showAllButtonsTitle = String.topics.localized(
        "seeAllTopicsButtonText"
    )
    @Published var showingEditScreen: Bool = false
    let editButtonTitle = String.common.localized("editButtonTitle")


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
        fetchAllTopics()
    }

    lazy var editTopicViewModel: EditTopicsViewModel = {
        EditTopicsViewModel(
            topicsService: topicsService,
            analyticsService: analyticsService
        )
    }()

    func updateShowAllButtonVisibility() {
        showAllTopicsButton =
        (topicsToBeDisplayed.count >= topicsService.fetchAll().count) ||
        fetchTopicsError
    }

    var widgetTitle: String {
        let key = topicsService.hasCustomisedTopics ?
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

    func fetchAllTopics() {
        allTopics = topicsService.fetchAll()
        print(allTopics)
    }

    var showAllButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: showAllButtonsTitle,
            action: { [weak self] in
                self?.allTopicsAction()
            }
        )
    }

    func trackECommerce() {
        if !showingEditScreen && initialLoadComplete {
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
