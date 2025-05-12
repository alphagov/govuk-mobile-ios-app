import UIKit
import Foundation
import GOVKit

class SignInErrorCoordinator: BaseCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let analyticsService: AnalyticsServiceInterface
    private let completion: () -> Void

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         analyticsService: AnalyticsServiceInterface,
         completion: @escaping () -> Void) {
        self.viewControllerBuilder = viewControllerBuilder
        self.analyticsService = analyticsService
        self.completion = completion
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewController = viewControllerBuilder.signInError(
            analyticsService: analyticsService,
            completion: { [weak self] in
                self?.finish()
            }
        )
        set(viewController, animated: false)
    }

    override func finish() {
        super.finish()
        self.completion()
    }
}
