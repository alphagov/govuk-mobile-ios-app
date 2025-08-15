import Foundation
import UIKit
import GOVKit
import UIComponents
import SwiftUI

class HomeViewModel: ObservableObject {
    let analyticsService: AnalyticsServiceInterface
    let configService: AppConfigServiceInterface
    let notificationService: NotificationServiceInterface
    let topicsWidgetViewModel: TopicsWidgetViewModel
    let localAuthorityAction: () -> Void
    let editLocalAuthorityAction: () -> Void
    let feedbackAction: () -> Void
    let notificationsAction: () -> Void
    let recentActivityAction: () -> Void
    let openURLAction: (URL) -> Void
    let openAction: (SearchItem) -> Void
    let urlOpener: URLOpener
    let searchService: SearchServiceInterface
    let activityService: ActivityServiceInterface
    let localAuthorityService: LocalAuthorityServiceInterface
    @Published var homeContentScrollToTop: Bool = false

    init(analyticsService: AnalyticsServiceInterface,
         configService: AppConfigServiceInterface,
         notificationService: NotificationServiceInterface,
         topicsWidgetViewModel: TopicsWidgetViewModel,
         urlOpener: URLOpener,
         searchService: SearchServiceInterface,
         activityService: ActivityServiceInterface,
         localAuthorityService: LocalAuthorityServiceInterface,
         localAuthorityAction: @escaping () -> Void,
         editLocalAuthorityAction: @escaping () -> Void,
         feedbackAction: @escaping () -> Void,
         notificationsAction: @escaping () -> Void,
         recentActivityAction: @escaping () -> Void,
         openURLAction: @escaping (URL) -> Void,
         openAction: @escaping (SearchItem) -> Void) {
        self.analyticsService = analyticsService
        self.configService = configService
        self.notificationService = notificationService
        self.topicsWidgetViewModel = topicsWidgetViewModel
        self.localAuthorityAction = localAuthorityAction
        self.editLocalAuthorityAction = editLocalAuthorityAction
        self.feedbackAction = feedbackAction
        self.notificationsAction = notificationsAction
        self.recentActivityAction = recentActivityAction
        self.openURLAction = openURLAction
        self.openAction = openAction
        self.urlOpener = urlOpener
        self.searchService = searchService
        self.activityService = activityService
        self.localAuthorityService = localAuthorityService
    }

    var widgets: [HomepageWidget] {
        let array = [topicsView].compactMap { $0 }
        return array
    }

    var topicsView: HomepageWidget? {
        guard featureEnabled(.topics)
        else { return nil }
        return HomepageWidget(
            content: TopicsView(
                viewModel: self.topicsWidgetViewModel
            )
        )
    }

    lazy var searchEnabled = featureEnabled(.search)
    lazy var searchViewModel: SearchViewModel = SearchViewModel(
        analyticsService: analyticsService,
        searchService: searchService,
        activityService: activityService,
        urlOpener: urlOpener,
        openAction: openAction
    )

    private func featureEnabled(_ feature: Feature) -> Bool {
        configService.isFeatureEnabled(key: feature)
    }

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }
}
