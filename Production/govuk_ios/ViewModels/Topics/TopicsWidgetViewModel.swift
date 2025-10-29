import Foundation
import UIKit
import CoreData
import GOVKit
import UIComponents

enum TopicSegment {
    case favorite
    case all
}

final class TopicsWidgetViewModel: ObservableObject {
    private let topicsService: TopicsServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    private let urlOpener: URLOpener
    let topicAction: (Topic) -> Void
    @Published var fetchTopicsError = false
    @Published var favouriteTopics: [Topic] = []
    @Published var allTopics: [Topic] = []
    @Published var topicsScreen: TopicSegment = .favorite

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
         topicAction: @escaping (Topic) -> Void) {
        self.topicsService = topicsService
        self.analyticsService = analyticsService
        self.urlOpener = urlOpener
        self.topicAction = topicAction
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

    func setTopicsScreen() {
        topicsScreen = hasFavouritedTopics ? .favorite : .all
    }

    @MainActor
    func refreshTopics() {
        fetchTopics()
        updateFavouriteTopics()
        updateAllTopics()
        setTopicsScreen()
    }


    func openErrorURL() {
        urlOpener.openIfPossible(Constants.API.govukBaseUrl)
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
}
