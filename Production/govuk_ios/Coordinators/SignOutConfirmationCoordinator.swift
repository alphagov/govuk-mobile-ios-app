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
            completion: { [weak self] in
                self?.dismiss()
            }
        )
        set([viewController])
    }

    private func dismiss() {
        self.finish()
        root.dismiss(animated: authenticationService.isSignedIn)
    }
}
