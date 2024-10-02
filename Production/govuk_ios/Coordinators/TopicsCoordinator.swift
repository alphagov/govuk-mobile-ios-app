import UIKit

final class TopicsCoordinator: BaseCoordinator {
    private let analyticsService: AnalyticsServiceInterface
    private let viewControllerBuilder: ViewControllerBuilder
    private let topic: Topic

    init(navigationController: UINavigationController,
         analyticsService: AnalyticsServiceInterface,
         viewControllerBuilder: ViewControllerBuilder,
         topic: Topic) {
        self.analyticsService = analyticsService
        self.viewControllerBuilder = viewControllerBuilder
        self.topic = topic
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewController = viewControllerBuilder.topicDetail(
            topic: topic,
            analyticsService: analyticsService
        )
        push(viewController, animated: true)
    }
}
