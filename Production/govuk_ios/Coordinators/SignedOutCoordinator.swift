import UIKit
import Foundation
import GOVKit

class SignedOutCoordinator: BaseCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let authenticationService: AuthenticationServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    private let completion: () -> Void

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         authenticationService: AuthenticationServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         completion: @escaping () -> Void) {
        self.viewControllerBuilder = viewControllerBuilder
        self.authenticationService = authenticationService
        self.analyticsService = analyticsService
        self.completion = completion
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewController = viewControllerBuilder.signedOut(
            authenticationService: authenticationService,
            analyticsService: analyticsService,
            completion: { [weak self] in
                self?.completion()
            }
        )
        set(viewController, animated: false)
    }
}
