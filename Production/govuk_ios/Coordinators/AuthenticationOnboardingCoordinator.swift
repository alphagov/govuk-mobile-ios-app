import Foundation
import UIKit
import Onboarding

class AuthenticationOnboardingCoordinator: BaseCoordinator {
    private let navigationController: UINavigationController
    private let analyticsService: OnboardingAnalyticsService
    private let authenticationOnboardingService: AuthenticationOnboardingServiceInterface
    private let coordinatorBuilder: CoordinatorBuilder
    private let completionAction: () -> Void

    init(navigationController: UINavigationController,
         analyticsService: OnboardingAnalyticsService,
         authenticationOnboardingService: AuthenticationOnboardingServiceInterface,
         coordinatorBuilder: CoordinatorBuilder,
         completionAction: @escaping () -> Void) {
        self.navigationController = navigationController
        self.authenticationOnboardingService = authenticationOnboardingService
        self.analyticsService = analyticsService
        self.coordinatorBuilder = coordinatorBuilder
        self.completionAction = completionAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard !authenticationOnboardingService.hasSeenOnboarding else {
            finishCoordination()
            return
        }

        setOnboarding()
    }

    private func setOnboarding() {
        let onboardingModule = Onboarding(
            slideProvider: authenticationOnboardingService,
            analyticsService: analyticsService,
            completeAction: { [weak self] in
                self?.authenticationOnboardingService.setHasSeenOnboarding()
                Task {
                    await self?.authenticateAction()
                }
            },
            dismissAction: { [weak self] in
                self?.authenticationOnboardingService.setHasSeenOnboarding()
                self?.finishCoordination()
            }
        )
        set(onboardingModule.viewController)
    }

    private func finishCoordination() {
        DispatchQueue.main.async {
            self.completionAction()
        }
    }

    private func authenticateAction() async {
        let authenticationCoordinator = coordinatorBuilder.authentication(
            navigationController: navigationController,
            completionAction: completionAction
        )
        authenticationCoordinator.start()
    }
}
