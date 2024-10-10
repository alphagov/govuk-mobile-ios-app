import UIKit
import Foundation
import Factory

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
        let viewModel = GroupedListViewModel(
            activityService: Container.shared.activityService()
        )
        let viewController = GroupedListViewController(
            viewModel: viewModel
        )
        push(viewController, animated: true)
    }
}
