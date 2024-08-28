import UIKit
import Foundation

class SearchCoordinator: BaseCoordinator {
    let analyticsService: AnalyticsServiceInterface
    private let viewControllerBuilder: ViewControllerBuilder

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         analyticsService: AnalyticsServiceInterface) {
        self.viewControllerBuilder = viewControllerBuilder
        self.analyticsService = analyticsService
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewController = viewControllerBuilder.search(
            analyticsService: analyticsService
        )
        set(viewController, animated: true)
    }
}
