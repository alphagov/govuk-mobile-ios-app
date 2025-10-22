import Foundation
import UIKit
import CoreData
import GOVKit
import UIComponents


final class TopicsWidgetViewModel: ObservableObject {
    private let topicsService: TopicsServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    let urlOpener: URLOpener
    let topicAction: (Topic) -> Void
    @Published var fetchTopicsError = false
    @Published var topicsToBeDisplayed: [Topic] = []
    @Published var allTopics: [Topic] = []
    let editButtonTitle = String.common.localized(
        "editButtonTitle"
    )
    let errorDescription = String.home.localized(
        "topicWidgetErrorDescription"
    )
    @Published var topicsScreen: Int = 0
    let errorTitle = String.home.localized(
        "topicWidgetErrorTitle"
    )
    let errorLink = String.home.localized(
        "topicWidgetErrorLink"
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

    let widgetTitle = String.home.localized(
        "topicsWidgetTitle"
    )

    func fetchDisplayedTopics() {
        topicsToBeDisplayed =
        topicsService.hasCustomisedTopics ?
        topicsService.fetchFavourites() :
        topicsService.fetchAll()
    }

    func fetchAllTopics() {
        allTopics = topicsService.fetchAll()
    }

    func setTopicsScreen() {
        topicsScreen = hasFavouritedTopics ? 0 : 1
    }

    var hasFavouritedTopics: Bool {
        topicsService.fetchFavourites() != []
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
