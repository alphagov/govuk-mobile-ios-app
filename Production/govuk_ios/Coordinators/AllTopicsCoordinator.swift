import UIKit

final class AllTopicsCoordinator: BaseCoordinator {
    private let analyticsService: AnalyticsServiceInterface
    private let viewControllerBuilder: ViewControllerBuilder
    private let topicsService: TopicsServiceInterface
    private let coordinatorBuilder: CoordinatorBuilder

    init(navigationController: UINavigationController,
         analyticsService: AnalyticsServiceInterface,
         viewControllerBuilder: ViewControllerBuilder,
         topicsService: TopicsServiceInterface,
         coordinatorBuilder: CoordinatorBuilder) {
        self.analyticsService = analyticsService
        self.viewControllerBuilder = viewControllerBuilder
        self.topicsService = topicsService
        self.coordinatorBuilder = coordinatorBuilder
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewController = viewControllerBuilder.allTopics(
            topicsService: topicsService,
            analyticsService: analyticsService,
            topicAction: topicAction
        )
        push(viewController, animated: true)
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
}
