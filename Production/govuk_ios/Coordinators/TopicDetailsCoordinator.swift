import UIKit
import GOVKit
import RecentActivity

final class TopicDetailsCoordinator: BaseCoordinator {
    private let analyticsService: AnalyticsServiceInterface
    private let topicsService: TopicsServiceInterface
    private let activityService: ActivityServiceInterface
    private let viewControllerBuilder: ViewControllerBuilder
    private let topic: Topic

    init(navigationController: UINavigationController,
         analyticsService: AnalyticsServiceInterface,
         topicsService: TopicsServiceInterface,
         activityService: ActivityServiceInterface,
         viewControllerBuilder: ViewControllerBuilder,
         topic: Topic) {
        self.analyticsService = analyticsService
        self.viewControllerBuilder = viewControllerBuilder
        self.topicsService = topicsService
        self.activityService = activityService
        self.topic = topic
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        pushTopic(topic)
    }

    private var pushTopic: (DisplayableTopic) -> Void {
        return { [weak self] localTopic in
            guard let self = self
            else { return }
            let viewController = self.viewControllerBuilder.topicDetail(
                topic: localTopic,
                topicsService: self.topicsService,
                analyticsService: self.analyticsService,
                activityService: self.activityService,
                subtopicAction: self.pushTopic,
                stepByStepAction: self.pushStepBySteps
            )
            self.push(viewController, animated: true)
        }
    }

    private var pushStepBySteps: ([TopicDetailResponse.Content]) -> Void {
        return { [weak self] localContent in
            guard let self = self
            else { return }
            let viewController = self.viewControllerBuilder.stepByStep(
                content: localContent,
                analyticsService: self.analyticsService,
                activityService: self.activityService
            )
            self.push(viewController, animated: true)
        }
    }
}
