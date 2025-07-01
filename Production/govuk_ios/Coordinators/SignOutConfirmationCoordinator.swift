import UIKit
import Foundation
import GOVKit

final class SignOutConfirmationCoordinator: BaseCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let authenticationService: AuthenticationServiceInterface
    private let analyticsService: AnalyticsServiceInterface

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         authenticationService: AuthenticationServiceInterface,
         analyticsService: AnalyticsServiceInterface) {
        self.viewControllerBuilder = viewControllerBuilder
        self.authenticationService = authenticationService
        self.analyticsService = analyticsService
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewController = viewControllerBuilder.signOutConfirmation(
            authenticationService: authenticationService,
            analyticsService: analyticsService,
            completion: { [weak self] didAttemptSignOut in
                self?.dismiss(didAttemptSignOut)
            }
        )
        set([viewController])
    }

    private func dismiss(_ didAttemptSignOut: Bool) {
        if didAttemptSignOut {
            finish()
        }
        root.dismiss(animated: true)
    }
}
