import Foundation
import UIKit
import GOVKit

class HomeCoordinator: TabItemCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let viewControllerBuilder: ViewControllerBuilder
    private let deeplinkStore: DeeplinkDataStore
    private let analyticsService: AnalyticsServiceInterface
    private let configService: AppConfigServiceInterface
    private let topicsService: TopicsServiceInterface
    private let notificationService: NotificationServiceInterface

    private let deviceInformationProvider: DeviceInformationProviderInterface
    private let searchService: SearchServiceInterface
    private let activityService: ActivityServiceInterface
    private let localAuthorityService: LocalAuthorityServiceInterface

    init(navigationController: UINavigationController,
         coordinatorBuilder: CoordinatorBuilder,
         viewControllerBuilder: ViewControllerBuilder,
         deeplinkStore: DeeplinkDataStore,
         analyticsService: AnalyticsServiceInterface,
         configService: AppConfigServiceInterface,
         topicsService: TopicsServiceInterface,
         notificationService: NotificationServiceInterface,
         deviceInformationProvider: DeviceInformationProviderInterface,
         searchService: SearchServiceInterface,
         activityService: ActivityServiceInterface,
         localAuthorityService: LocalAuthorityServiceInterface) {
        self.coordinatorBuilder = coordinatorBuilder
        self.viewControllerBuilder = viewControllerBuilder
        self.deeplinkStore = deeplinkStore
        self.analyticsService = analyticsService
        self.configService = configService
        self.topicsService = topicsService
        self.notificationService = notificationService
        self.deviceInformationProvider = deviceInformationProvider
        self.searchService = searchService
        self.activityService = activityService
        self.localAuthorityService = localAuthorityService
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let dependencies = ViewControllerBuilder.HomeDependencies(
            analyticsService: analyticsService,
            configService: configService,
            notificationService: notificationService,
            searchService: searchService,
            activityService: activityService,
            topicWidgetViewModel: topicWidgetViewModel,
            localService: localAuthorityService
        )

        let actions = ViewControllerBuilder.HomeActions(
            feedbackAction: feedbackAction,
            notificationsAction: notificationsAction,
            recentActivityAction: startRecentActivityCoordinator,
            localAuthorityAction: trackLocalAuthorityWidget
        )

        let viewController = viewControllerBuilder.home(
            dependencies: dependencies,
            actions: actions
        )
        set([viewController], animated: false)
    }

    func route(for url: URL) -> ResolvedDeeplinkRoute? {
        deeplinkStore.route(
            for: url,
            parent: self
        )
    }

    func didReselectTab() {
        guard let homeViewController = root.viewControllers.first as? ResetsToDefault
        else { return }
        if childCoordinators.isEmpty {
            homeViewController.resetState()
        }
    }

    private var trackLocalAuthorityWidget: () -> Void {
        return { [weak self] in
            self?.trackWidgetNavigation(text: "Your local services")
        }
    }

    private var notificationsAction: () -> Void {
        return { [weak self] in
            guard let self = self else { return }
            self.trackWidgetNavigation(
                text: String.home.localized("notificationWidgetTitle")
            )
            self.notificationService.requestPermissions { self.start(url: nil) }
        }
    }

    private var feedbackAction: () -> Void {
        return { [weak self] in
            guard let self = self else { return }
            self.trackWidgetNavigation(
                text: String.home.localized("feedbackWidgetTitle"),
                external: true
            )
            let urlOpener: URLOpener = UIApplication.shared
            urlOpener.openIfPossible(
                self.deviceInformationProvider.helpAndFeedbackURL(versionProvider: Bundle.main)
            )
        }
    }

    private var startRecentActivityCoordinator: () -> Void {
        return { [weak self] in
            self?.trackWidgetNavigation(text: "Pages you’ve visited")
            guard let self = self else { return }
            let coordinator = self.coordinatorBuilder.recentActivity(
                navigationController: self.root
            )
            start(coordinator)
        }
    }

    private var startTopicDetailCoordinator: (Topic) -> Void {
        return { [weak self] topic in
            self?.trackWidgetNavigation(text: topic.title)
            guard let self = self else { return }
            let coordinator = self.coordinatorBuilder.topicDetail(
                topic,
                navigationController: self.root
            )
            start(coordinator)
        }
    }

    private var startAllTopicsCoordinator: () -> Void {
        return { [weak self] in
            self?.trackWidgetNavigation(text: "See all topics")
            guard let self = self else { return }
            let coordinator = self.coordinatorBuilder.allTopics(
                navigationController: self.root
            )
            start(coordinator)
        }
    }

    private var presentEditTopicsCoordinator: () -> Void {
        return { [weak self] in
            self?.trackWidgetNavigation(text: "EditTopics")
            guard let self = self else { return }
            self.topicWidgetViewModel.isEditing = true
            let navigationController = UINavigationController()
            let coordinator = self.coordinatorBuilder.editTopics(
                navigationController: navigationController,
                didDismissAction: {
                    self.topicWidgetViewModel.isEditing = false
                    self.root.viewWillReAppear()
                }
            )
            self.present(coordinator)
        }
    }

    private lazy var topicWidgetViewModel: TopicsWidgetViewModel = {
        TopicsWidgetViewModel(
            topicsService: topicsService,
            analyticsService: analyticsService,
            topicAction: startTopicDetailCoordinator,
            editAction: presentEditTopicsCoordinator,
            allTopicsAction: startAllTopicsCoordinator
        )
    }()

    private func trackWidgetNavigation(text: String,
                                       external: Bool = false) {
        let event = AppEvent.widgetNavigation(
            text: text,
            external: external
        )
        analyticsService.track(event: event)
    }
}
