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
    private let deviceInformationProvider: DeviceInformationProviderInterface

    init(navigationController: UINavigationController,
         coordinatorBuilder: CoordinatorBuilder,
         viewControllerBuilder: ViewControllerBuilder,
         deeplinkStore: DeeplinkDataStore,
         analyticsService: AnalyticsServiceInterface,
         configService: AppConfigServiceInterface,
         topicsService: TopicsServiceInterface,
         deviceInformationProvider: DeviceInformationProviderInterface) {
        self.coordinatorBuilder = coordinatorBuilder
        self.viewControllerBuilder = viewControllerBuilder
        self.deeplinkStore = deeplinkStore
        self.analyticsService = analyticsService
        self.configService = configService
        self.topicsService = topicsService
        self.deviceInformationProvider = deviceInformationProvider
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewController = viewControllerBuilder.home(
            analyticsService: analyticsService,
            configService: configService,
            topicWidgetViewModel: topicWidgetViewModel,
            feedbackAction: feedbackAction,
            searchAction: presentSearchCoordinator,
            recentActivityAction: startRecentActivityCoordinator,
            widgetBuilder: WidgetBuilder(coordinator: self,
                                         analytics: self.analyticsService,
                                         configService: configService,
                                         topicWidgetViewModel: topicWidgetViewModel,
                                         feedbackAction: feedbackAction,
                                         searchAction: presentSearchCoordinator,
                                         recentActivityAction: startRecentActivityCoordinator)
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
        guard let homeViewController = root.viewControllers.first as? ContentScrollable
        else {
            return
        }
        if childCoordinators.isEmpty {
            homeViewController.scrollToTop()
        }
    }

    private var feedbackAction: () -> Void {
        return { [weak self] in
            guard let self = self else { return }
            self.trackWidgetNavigation(text: String.home.localized("feedbackWidgetTitle"),
                                        external: true)
            let urlOpener: URLOpener = UIApplication.shared
            urlOpener.openIfPossible(
                self.deviceInformationProvider.helpAndFeedbackURL(versionProvider: Bundle.main)
            )
        }
    }

    private var presentSearchCoordinator: () -> Void {
        return { [weak self] in
            self?.trackWidgetNavigation(text: "Search")
            guard let strongSelf = self else { return }
            let navigationController = UINavigationController()
            let coordinator = strongSelf.coordinatorBuilder.search(
                navigationController: navigationController,
                didDismissAction: {
                    self?.root.viewWillReAppear()
                }
            )
            strongSelf.present(coordinator)
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
