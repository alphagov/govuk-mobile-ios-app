import Foundation
import UIKit
import Onboarding

class AuthenticationOnboardingCoordinator: BaseCoordinator {
    private let analyticsService: OnboardingAnalyticsService
    private let authenticationService: AuthenticationServiceInterface
    private let completeAction: () -> Void

    init(navigationController: UINavigationController,
         analyticsService: OnboardingAnalyticsService,
         authenticationService: AuthenticationServiceInterface,
         completionAction: @escaping () -> Void) {
        self.authenticationService = authenticationService
        self.analyticsService = analyticsService
        self.completeAction = completionAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        setOnboarding()
    }

    private func setOnboarding() {
        let onboardingModule = Onboarding(
            slideProvider: authenticationService,
            analyticsService: analyticsService,
            completeAction: { [weak self] in
//                self?.authenticationService.setHasSeenOnboarding()
                self?.finishCoordination()
            },
            dismissAction: { [weak self] in
//                self?.authenticationService.setHasSeenOnboarding()
                self?.finishCoordination()
            }
        )
        set(onboardingModule.viewController)
    }

    private func finishCoordination() {
        DispatchQueue.main.async {
            self.completeAction()
        }
    }
}
