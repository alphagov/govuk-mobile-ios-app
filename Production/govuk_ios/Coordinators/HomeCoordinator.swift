import UIKit
import Foundation

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
            searchButtonPrimaryAction: searchActionButtonPressed,
            configService: configService,
            topicsService: topicsService,
            recentActivityAction: recentActivityCoordinator,
            topicAction: topicAction,
            allTopicsAction: allTopicsAction
        )
        set([viewController], animated: false)
    }

    func route(for url: URL) -> ResolvedDeeplinkRoute? {
        deeplinkStore.route(
            for: url,
            parent: self
        )
    }

    private var searchActionButtonPressed: () -> Void {
        return { [weak self] in
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

    private var recentActivityCoordinator: () -> Void {
        return { [weak self] in
            guard let self = self else { return }
            let coordinator = self.coordinatorBuilder.recentActivity(
                navigationController: self.root
            )
            start(coordinator)
        }
    }

    private var topicAction: (Topic) -> Void {
        return { [weak self] topic in
            guard let self = self else { return }
            let coordinator = self.coordinatorBuilder.topicDetail(
                topic,
                navigationController: self.root
            )
            start(coordinator)
        }
    }

    private var allTopicsAction: () -> Void {
        return { [weak self] in
            guard let self = self else { return }
            let coordinator = self.coordinatorBuilder.allTopics(
                navigationController: self.root
            )
            start(coordinator)
        }
    }
}
