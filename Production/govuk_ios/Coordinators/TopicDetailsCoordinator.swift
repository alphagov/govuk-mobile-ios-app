import UIKit

final class TopicDetailsCoordinator: BaseCoordinator {
    private let analyticsService: AnalyticsServiceInterface
    private let topicsService: TopicsServiceInterface
    private let viewControllerBuilder: ViewControllerBuilder
    private let topic: Topic

    init(navigationController: UINavigationController,
         analyticsService: AnalyticsServiceInterface,
         topicsService: TopicsServiceInterface,
         viewControllerBuilder: ViewControllerBuilder,
         topic: Topic) {
        self.analyticsService = analyticsService
        self.viewControllerBuilder = viewControllerBuilder
        self.topicsService = topicsService
        self.topic = topic
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewController = viewControllerBuilder.topicDetail(
            topicRef: topic.ref,
            topicsService: topicsService,
            analyticsService: analyticsService,
            navigationAction: goToSubtopic
        )
        push(viewController, animated: true)
    }

    func goToSubtopic(_ topicRef: String) {
        let viewController = viewControllerBuilder.topicDetail(
            topicRef: topicRef,
            topicsService: topicsService,
            analyticsService: analyticsService,
            navigationAction: goToSubtopic
        )
        push(viewController, animated: true)
    }
}
