import Foundation
import UIKit
import GOVKit
import UIComponents
import SwiftUI

class HomeViewModel: ObservableObject {
    let analyticsService: AnalyticsServiceInterface
    let configService: AppConfigServiceInterface
    let notificationService: NotificationServiceInterface
    let userDefaultsService: UserDefaultsServiceInterface
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
    @Published var widgets: [HomepageWidget] = []

    init(analyticsService: AnalyticsServiceInterface,
         configService: AppConfigServiceInterface,
         notificationService: NotificationServiceInterface,
         userDefaultsService: UserDefaultsServiceInterface,
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
        self.userDefaultsService = userDefaultsService
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
        updateWidgets()
    }

    func updateWidgets() {
        let array = [
            topicsWidget,
            addLocalAuthorityWidget,
            storedLocalAuthorityWidget,
            recentActivityWidget
        ].compactMap { $0 }
        widgets = bannerWidgets + array
    }

    private var bannerWidgets: [HomepageWidget] {
        guard let banners = configService.emergencyBanners else {
            return []
        }

        let visibleBanners = banners.filter { !userDefaultsService.hasSeen(banner: $0) }

        return visibleBanners.enumerated().map { iterator in
            let viewModel = EmergencyBannerWidgetViewModel(
                banner: iterator.element,
                analyticsService: analyticsService,
                sortPriority: (visibleBanners.count - iterator.offset),
                openURLAction: openURLAction,
                dismissAction: {
                    self.userDefaultsService.markSeen(banner: iterator.element)
                    self.updateWidgets()
                }
            )

            return HomepageWidget(
                content: EmergencyBannerWidgetView(
                    viewModel: viewModel
                )
            )
        }
    }

    private var topicsWidget: HomepageWidget? {
        guard featureEnabled(.topics)
        else { return nil }
        return HomepageWidget(
            content: TopicsWidget(
                viewModel: self.topicsWidgetViewModel
            )
        )
    }

    private var storedLocalAuthorityWidget: HomepageWidget? {
        guard featureEnabled(.localServices) else { return nil }
        let localAuthorities = localAuthorityService.fetchSavedLocalAuthority()
        guard localAuthorities.count > 0 else { return nil }

        let viewModel = StoredLocalAuthorityWidgetViewModel(
            analyticsService: analyticsService,
            localAuthorities: localAuthorities,
            openURLAction: openURLAction,
            openEditViewAction: editLocalAuthorityAction
        )
        let view = StoredLocalAuthorityWidgetView(
            viewModel: viewModel
        )
        return HomepageWidget(
            content: view
        )
    }

    private var recentActivityWidget: HomepageWidget? {
        guard featureEnabled(.recentActivity)
        else { return nil }
        let viewModel = RecentActivityHomepageWidgetViewModel(
            analyticsService: analyticsService,
            activityService: activityService,
            seeAllAction: { [weak self] in
                self?.recentActivityAction()
            },
            openURLAction: openURLAction
        )
        let view = RecentActivityWidget(viewModel: viewModel)
        return HomepageWidget(
            content: view
        )
    }

    private var addLocalAuthorityWidget: HomepageWidget? {
        guard featureEnabled(.localServices),
              localAuthorityService.fetchSavedLocalAuthority().isEmpty
        else { return nil }
        let viewModel = LocalAuthorityWidgetViewModel { [weak self] in
            self?.localAuthorityAction()
        }
        let view = LocalAuthorityWidget(
            viewModel: viewModel
        )
        return HomepageWidget(
            content: view
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
}
