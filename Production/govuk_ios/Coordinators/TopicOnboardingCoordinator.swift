import UIKit
import Foundation
import Factory

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
        setViewController()
    }

    private func setViewController() {
        let viewController = viewControllerBuilder.topicOnboarding(
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
