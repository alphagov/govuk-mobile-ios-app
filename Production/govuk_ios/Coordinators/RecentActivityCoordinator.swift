import UIKit
import Foundation
import Factory

class RecentActivityCoordinator: BaseCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let analyticsService: AnalyticsServiceInterface
    private let activityService: ActivityServiceInterface

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         analyticsService: AnalyticsServiceInterface,
         activityService: ActivityServiceInterface) {
        self.viewControllerBuilder = viewControllerBuilder
        self.analyticsService = analyticsService
        self.activityService = activityService
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewController = viewControllerBuilder.recentActivity(
            analyticsService: analyticsService,
            activityService: activityService
        )
        push(viewController, animated: true)
    }
}
