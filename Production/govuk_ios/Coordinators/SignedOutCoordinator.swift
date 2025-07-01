import UIKit
import Foundation
import GOVKit

class SignedOutCoordinator: BaseCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let authenticationService: AuthenticationServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    private let completion: (Bool) -> Void

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         authenticationService: AuthenticationServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         completion: @escaping (Bool) -> Void) {
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
                guard let self = self else { return }
                self.completion(self.authenticationService.isSignedIn)
            }
        )
        set(viewController, animated: false)
    }
}
