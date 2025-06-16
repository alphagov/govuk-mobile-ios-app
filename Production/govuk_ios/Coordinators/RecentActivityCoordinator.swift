import UIKit
import Foundation
import GOVKit

class RecentActivityCoordinator: BaseCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let analyticsService: AnalyticsServiceInterface
    private let activityService: ActivityServiceInterface
    private let coordinatorBuilder: CoordinatorBuilder

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         analyticsService: AnalyticsServiceInterface,
         activityService: ActivityServiceInterface,
         coordinatorBuilder: CoordinatorBuilder) {
        self.viewControllerBuilder = viewControllerBuilder
        self.analyticsService = analyticsService
        self.activityService = activityService
        self.coordinatorBuilder = coordinatorBuilder
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewController = viewControllerBuilder.recentActivity(
            analyticsService: analyticsService,
            activityService: activityService,
            selectedAction: { [weak self] url in
                self?.presentWebView(url: url)
            }
        )
        push(viewController, animated: true)
    }

    private func presentWebView(url: URL) {
        let coordinator = coordinatorBuilder.safari(
            presentingViewController: root,
            url: url,
            fullScreen: true
        )
        start(coordinator, url: url)
    }
}
