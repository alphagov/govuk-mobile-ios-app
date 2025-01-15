import UIKit
import GOVKit

final class AllTopicsCoordinator: BaseCoordinator {
    private let analyticsService: AnalyticsServiceInterface
    private let viewControllerBuilder: ViewControllerBuilder
    private let coordinatorBuilder: CoordinatorBuilder
    private let topicsService: TopicsServiceInterface

    init(navigationController: UINavigationController,
         analyticsService: AnalyticsServiceInterface,
         viewControllerBuilder: ViewControllerBuilder,
         coordinatorBuilder: CoordinatorBuilder,
         topicsService: TopicsServiceInterface) {
        self.analyticsService = analyticsService
        self.viewControllerBuilder = viewControllerBuilder
        self.coordinatorBuilder = coordinatorBuilder
        self.topicsService = topicsService
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewController = viewControllerBuilder.allTopics(
            analyticsService: analyticsService,
            topicAction: startTopicDetailCoordinator,
            topicsService: topicsService
        )
        push(viewController, animated: true)
    }

    private var startTopicDetailCoordinator: (Topic) -> Void {
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
