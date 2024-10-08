import UIKit
import Foundation

class RecentActivityCoordinator: BaseCoordinator {
    private let analyticsService: AnalyticsServiceInterface
    private let viewControllerBuilder: ViewControllerBuilder

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         analyticsService: AnalyticsServiceInterface) {
        self.viewControllerBuilder = viewControllerBuilder
        self.analyticsService = analyticsService
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
//        let viewController = viewControllerBuilder.recentActivity(
//            analyticsService: analyticsService
//        )
        let viewController = GroupedListViewController(viewModel: .init())
        push(viewController, animated: true)
    }
}
