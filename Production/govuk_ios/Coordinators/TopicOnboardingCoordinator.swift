import UIKit
import Foundation
import Factory
import GOVKit

class TopicOnboardingCoordinator: BaseCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let analyticsService: AnalyticsServiceInterface
    private let topicsService: TopicsServiceInterface
    private let dismissAction: () -> Void

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         analyticsService: AnalyticsServiceInterface,
         topicsService: TopicsServiceInterface,
         dismissAction: @escaping () -> Void) {
        self.viewControllerBuilder = viewControllerBuilder
        self.analyticsService = analyticsService
        self.topicsService = topicsService
        self.dismissAction = dismissAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard !topicsService.hasOnboardedTopics
        else { return dismissAction() }

        let topics = topicsService.fetchAll()

        guard !topics.isEmpty
        else { return dismissAction() }

        setViewController(topics: topics)
    }

    private func setViewController(topics: [Topic]) {
        let viewController = viewControllerBuilder.topicOnboarding(
            topics: topics,
            analyticsService: analyticsService,
            topicsService: topicsService,
            dismissAction: { [weak self] in
                self?.topicsService.setHasOnboardedTopics()
                self?.dismissAction()
            }
        )
        set(viewController, animated: true)
    }
}
