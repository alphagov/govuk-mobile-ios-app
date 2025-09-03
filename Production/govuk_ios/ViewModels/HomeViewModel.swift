import Foundation
import UIKit
import GOVKit
import UIComponents

class HomeViewModel: ObservableObject {
    let analyticsService: AnalyticsServiceInterface
    let configService: AppConfigServiceInterface
    let notificationService: NotificationServiceInterface
    let topicWidgetViewModel: TopicsWidgetViewModel
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
    let userDefaultService: UserDefaultsServiceInterface
    @Published var widgets: [WidgetView] = []

    init(analyticsService: AnalyticsServiceInterface,
         configService: AppConfigServiceInterface,
         notificationService: NotificationServiceInterface,
         topicWidgetViewModel: TopicsWidgetViewModel,
         localAuthorityAction: @escaping () -> Void,
         editLocalAuthorityAction: @escaping () -> Void,
         feedbackAction: @escaping () -> Void,
         notificationsAction: @escaping () -> Void,
         recentActivityAction: @escaping () -> Void,
         openURLAction: @escaping (URL) -> Void,
         openAction: @escaping (SearchItem) -> Void,
         urlOpener: URLOpener,
         searchService: SearchServiceInterface,
         activityService: ActivityServiceInterface,
         localAuthorityService: LocalAuthorityServiceInterface,
         userDefaultService: UserDefaultsServiceInterface) {
        self.analyticsService = analyticsService
        self.configService = configService
        self.notificationService = notificationService
        self.topicWidgetViewModel = topicWidgetViewModel
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
        self.userDefaultService = userDefaultService
    }


    lazy var searchEnabled = featureEnabled(.search)
    lazy var searchViewModel: SearchViewModel = SearchViewModel(
        analyticsService: analyticsService,
        searchService: searchService,
        activityService: activityService,
        urlOpener: urlOpener,
        openAction: openAction
    )

    func reloadWidgets() async {
        widgets =
        await [
            alertBanner,
            localAuthorityWidget,
            // notificationsWidget, Removed until dismissable cards introduced
            recentActivityWidget,
            topicsWidget,
            storedLocalAuthorityWidget,
            userFeedbackWidget
        ].compactMap { $0 }
    }

    @MainActor
    private var alertBanner: WidgetView? {
        guard let alert = configService.alertBanner,
              !userDefaultService.hasSeen(banner: alert)
        else { return nil }

        let viewModel = AlertBannerWidgetViewModel(
            alert: alert,
            urlOpener: urlOpener,
            dismiss: {
                self.userDefaultService.markSeen(banner: alert)
                Task {
                    await self.reloadWidgets()
                }
            }
        )
        let content = AlertBannerWidgetView(
            viewModel: viewModel
        )
        let widget = WidgetView()
        widget.backgroundColor = UIColor.govUK.fills.surfaceCardBlue
        let hostingViewController = HostingViewController(
            rootView: content
        )
        widget.addContent(hostingViewController.view)
        return widget
    }

    @MainActor
    private var notificationsWidget: WidgetView? {
        get async {
            guard await notificationService.shouldRequestPermission
            else { return nil }

            let title = String.home.localized("notificationWidgetTitle")
            let viewModel = NotificationsWidgetViewModel(
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
    private var userFeedbackWidget: WidgetView? {
        guard let userFeedback = configService.userFeedbackBanner
        else { return nil }
        let viewModel = UserFeedbackWidgetViewModel(
            userFeedback: userFeedback,
            urlOpener: urlOpener
        )
        let widget = WidgetView(
            decorateView: false,
            useContentAccessibilityInfo: false,
            backgroundColor: .clear,
            borderColor: UIColor.clear.cgColor
        )
        let content = UserFeedbackWidgetView(
            viewModel: viewModel
        )
        let hostingViewController = HostingViewController(
            rootView: content
        )
        hostingViewController.view.backgroundColor = .clear
        widget.addContent(hostingViewController.view)
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
            useContentAccessibilityInfo: false,
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
            openURLAction: openURLAction,
            openEditViewAction: editLocalAuthorityAction
        )
        let content = StoredLocalAuthorityWidgetView(
            viewModel: viewModel
        )
        let hostingViewController = HostingViewController(
            rootView: content
        )
        hostingViewController.view.backgroundColor = .clear
        let widget = WidgetView(
            decorateView: false,
            useContentAccessibilityInfo: false
        )
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
