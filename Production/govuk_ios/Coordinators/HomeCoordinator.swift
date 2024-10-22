import Foundation
import UIKit

class HomeCoordinator: TabItemCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let viewControllerBuilder: ViewControllerBuilder
    private let deeplinkStore: DeeplinkDataStore
    private let analyticsService: AnalyticsServiceInterface
    private let configService: AppConfigServiceInterface
    private let topicsService: TopicsServiceInterface

    init(navigationController: UINavigationController,
         coordinatorBuilder: CoordinatorBuilder,
         viewControllerBuilder: ViewControllerBuilder,
         deeplinkStore: DeeplinkDataStore,
         analyticsService: AnalyticsServiceInterface,
         configService: AppConfigServiceInterface,
         topicsService: TopicsServiceInterface) {
        self.coordinatorBuilder = coordinatorBuilder
        self.viewControllerBuilder = viewControllerBuilder
        self.deeplinkStore = deeplinkStore
        self.analyticsService = analyticsService
        self.configService = configService
        self.topicsService = topicsService
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewController = viewControllerBuilder.home(
            analyticsService: analyticsService,
            configService: configService,
            topicWidgetViewModel: topicWidgetViewModel,
            searchAction: presentSearchCoordinator,
            recentActivityAction: startRecentActivityCoordinator
        )
        set([viewController], animated: false)
    }

    func route(for url: URL) -> ResolvedDeeplinkRoute? {
        deeplinkStore.route(
            for: url,
            parent: self
        )
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
            self?.trackWidgetNavigation(text: topic.ref)
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
            let navigationController = UINavigationController()
            let coordinator = self.coordinatorBuilder.editTopics(
                navigationController: navigationController,
                didDismissAction: {
                    self.root.viewWillReAppear()
                }
            )
            self.present(coordinator)
        }
    }

    private var topicWidgetViewModel: TopicsWidgetViewModel {
        TopicsWidgetViewModel(
            topicsService: topicsService,
            topicAction: startTopicDetailCoordinator,
            editAction: presentEditTopicsCoordinator,
            allTopicsAction: startAllTopicsCoordinator
        )
    }

    private func trackWidgetNavigation(text: String) {
        let event = AppEvent.widgetNavigation(
            text: text
        )
        analyticsService.track(event: event)
    }
}
