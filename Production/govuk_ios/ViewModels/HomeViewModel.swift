import Foundation
import UIKit
import GOVKit
import UIComponents

struct HomeViewModel {
    let analyticsService: AnalyticsServiceInterface
    let configService: AppConfigServiceInterface
    let notificationService: NotificationServiceInterface
    let topicWidgetViewModel: TopicsWidgetViewModel
    let localAuthorityAction: () -> Void
    let editLocalAuthorityAction: () -> Void
    let feedbackAction: () -> Void
    let notificationsAction: () -> Void
    let recentActivityAction: () -> Void
    let urlOpener: URLOpener
    let searchService: SearchServiceInterface
    let activityService: ActivityServiceInterface
    let localAuthorityService: LocalAuthorityServiceInterface

    lazy var searchEnabled = featureEnabled(.search)
    lazy var searchViewModel: SearchViewModel = SearchViewModel(
        analyticsService: analyticsService,
        searchService: searchService,
        activityService: activityService,
        urlOpener: urlOpener
    )

    var widgets: [WidgetView] {
        get async {
            await [
                localAuthorityWidget,
                notificationsWidget,
                //            feedbackWidget,  // see https://govukverify.atlassian.net/browse/GOVUKAPP-1220
                recentActivityWidget,
                topicsWidget,
                storedLocalAuthorityWidget
            ].compactMap { $0 }
        }
    }

    @MainActor
    private var notificationsWidget: WidgetView? {
        get async {
            guard await notificationService.shouldRequestPermission
            else { return nil }

            let title = String.home.localized("notificationWidgetTitle")
            let viewModel = UserFeedbackViewModel(
                title: title,
                action: notificationsAction
            )
            let content = InformationView(viewModel: viewModel, shouldHideChevron: true)
            let widget = WidgetView(useContentAccessibilityInfo: true)
            widget.backgroundColor = UIColor.govUK.fills.surfaceCardBlue
            widget.addContent(content)
            return widget
        }
    }

    @MainActor
    private var feedbackWidget: WidgetView {
        let title = String.home.localized("feedbackWidgetTitle")
        let viewModel = UserFeedbackViewModel(
            title: title,
            action: feedbackAction
        )
        let content = InformationView(viewModel: viewModel, shouldHideChevron: false)
        let widget = WidgetView(useContentAccessibilityInfo: true)
        widget.backgroundColor = UIColor.govUK.fills.surfaceCardBlue
        widget.addContent(content)
        return widget
    }

    @MainActor
    private var recentActivityWidget: WidgetView? {
        guard featureEnabled(.recentActivity)
        else { return nil }
        let title = String.home.localized(
            "recentActivityWidgetTitle"
        )

        let viewModel = RecentActivityWidgetViewModel(
            title: title,
            action: recentActivityAction
        )
        let content = RecentActivtyWidget(
            viewModel: viewModel
        )
        let widget = WidgetView(useContentAccessibilityInfo: true)
        widget.addContent(content)
        return widget
    }

    @MainActor
    private var localAuthorityWidget: WidgetView? {
        guard featureEnabled(.localServices),
              localAuthorityService.fetchSavedLocalAuthority().first == nil
        else { return nil }
        let viewModel = LocalAuthorityWidgetViewModel(
            tapAction: localAuthorityAction
        )
        let content = LocalAuthorityWidgetView(
            viewModel: viewModel
        )
        let hostingViewController = HostingViewController(
            rootView: content
        )
        let widget = WidgetView(
            useContentAccessibilityInfo: true,
            backgroundColor: UIColor.govUK.fills.surfaceCardSelected,
            borderColor: UIColor.govUK.strokes.cardGreen.cgColor
        )
        widget.addContent(hostingViewController.view)
        return widget
    }

    @MainActor
    private var storedLocalAuthorityWidget: WidgetView? {
        guard featureEnabled(.localServices) else { return nil }
        let localAuthorities = localAuthorityService.fetchSavedLocalAuthority()
        guard localAuthorities.count > 0 else { return nil }

        let viewModel = StoredLocalAuthorityWidgetViewModel(
            analyticsService: analyticsService,
            localAuthorities: localAuthorities,
            urlOpener: urlOpener,
            openEditViewAction: editLocalAuthorityAction
        )
        let content = StoredLocalAuthorityWidgetView(
            viewModel: viewModel
        )
        let hostingViewController = HostingViewController(
            rootView: content
        )
        let widget = WidgetView(decorateView: false)
        widget.addContent(hostingViewController.view)
        return widget
    }

    @MainActor
    private var topicsWidget: WidgetView? {
        guard featureEnabled(.topics)
        else { return nil }
        let content = TopicsWidgetView(
            viewModel: topicWidgetViewModel
        )
        let widget = WidgetView(decorateView: false)
        widget.addContent(content)
        return widget
    }

    private func featureEnabled(_ feature: Feature) -> Bool {
        configService.isFeatureEnabled(key: feature)
    }

    func trackECommerce() {
        topicWidgetViewModel.trackECommerce()
    }
}
