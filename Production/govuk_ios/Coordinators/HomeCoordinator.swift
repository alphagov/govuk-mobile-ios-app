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
    private let userDefaultsService: UserDefaultsServiceInterface
    private let chatService: ChatServiceInterface

    var isEnabled: Bool {
        true
    }

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
         localAuthorityService: LocalAuthorityServiceInterface,
         userDefaultService: UserDefaultsServiceInterface,
         chatService: ChatServiceInterface) {
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
        self.userDefaultsService = userDefaultService
        self.chatService = chatService
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let dependencies = ViewControllerBuilder.HomeDependencies(
            analyticsService: analyticsService,
            configService: configService,
            notificationService: notificationService,
            userDefaultsService: userDefaultsService,
            searchService: searchService,
            activityService: activityService,
            topicsWidgetViewModel: topicWidgetViewModel,
            localAuthorityService: localAuthorityService
        )

        let actions = ViewControllerBuilder.HomeActions(
            feedbackAction: feedbackAction,
            notificationsAction: notificationsAction,
            recentActivityAction: startRecentActivityCoordinator,
            localAuthorityAction: presentLocalAuthorityCoordinator,
            editLocalAuthorityAction: presentEditLocalAuthorityCoordinator,
            openURLAction: { [weak self] url in
                self?.presentWebView(url: url)
            },
            openSearchAction: { [weak self] item in
                self?.presentWebView(url: item.link)
            }
        )

        let viewController = viewControllerBuilder.home(
            dependencies: dependencies,
            actions: actions
        )
        set([viewController], animated: false)
    }

    private func presentWebView(url: URL) {
        let coordinator = coordinatorBuilder.safari(
            navigationController: root,
            url: url,
            fullScreen: true
        )
        start(coordinator, url: url)
    }

    func route(for url: URL) -> ResolvedDeeplinkRoute? {
        deeplinkStore.route(
            for: url,
            parent: self
        )
    }

    func didSelectTab(_ selectedTabIndex: Int,
                      previousTabIndex: Int) {
        if selectedTabIndex == previousTabIndex {
            guard let homeViewController = root.viewControllers.first as? ResetsToDefault
            else { return }
            if childCoordinators.isEmpty {
                homeViewController.resetState()
            }
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

    private var presentLocalAuthorityCoordinator: () -> Void {
        return { [weak self] in
            self?.trackWidgetNavigation(text: "Your local services")
            guard let self = self else { return }
            let navigationController = UINavigationController()
            let coordinator = self.coordinatorBuilder.localAuthority(
                navigationController: navigationController,
                dismissAction: {
                    self.root.viewWillReAppear()
                }
            )
            present(coordinator)
        }
    }

    private var presentEditLocalAuthorityCoordinator: () -> Void {
        return { [weak self] in
            self?.trackWidgetNavigation(text: "Edit your local services")
            guard let self = self else { return }
            let navigationController = UINavigationController()
            let coordinator = self.coordinatorBuilder.editLocalAuthority(
                navigationController: navigationController,
                dismissAction: {
                    self.root.viewWillReAppear()
                }
            )
            present(coordinator)
        }
    }

    private lazy var topicWidgetViewModel: TopicsWidgetViewModel = {
        TopicsWidgetViewModel(
            topicsService: topicsService,
            analyticsService: analyticsService,
            topicAction: startTopicDetailCoordinator
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
