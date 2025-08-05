import Foundation
import UIKit
import GOVKit
import UIComponents

struct HomeViewModel {
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

    func trackECommerce() {
        topicsWidgetViewModel.trackECommerce()
    }
}
