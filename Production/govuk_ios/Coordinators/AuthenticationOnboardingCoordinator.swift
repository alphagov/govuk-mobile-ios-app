import Foundation
import UIKit
import Onboarding

class AuthenticationOnboardingCoordinator: BaseCoordinator {
    private let navigationController: UINavigationController
    private let authenticationService: AuthenticationServiceInterface
    private let authenticationOnboardingService: AuthenticationOnboardingServiceInterface
    private let analyticsService: OnboardingAnalyticsService
    private let coordinatorBuilder: CoordinatorBuilder
    private let completionAction: () -> Void

    init(navigationController: UINavigationController,
         authenticationService: AuthenticationServiceInterface,
         authenticationOnboardingService: AuthenticationOnboardingServiceInterface,
         analyticsService: OnboardingAnalyticsService,
         coordinatorBuilder: CoordinatorBuilder,
         completionAction: @escaping () -> Void) {
        self.navigationController = navigationController
        self.authenticationService = authenticationService
        self.authenticationOnboardingService = authenticationOnboardingService
        self.analyticsService = analyticsService
        self.coordinatorBuilder = coordinatorBuilder
        self.completionAction = completionAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard !shouldSkipOnboarding else {
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
                Task {
                    await self?.authenticateAction()
                }
            },
            dismissAction: { [weak self] in
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

    private var shouldSkipOnboarding: Bool {
        !authenticationOnboardingService.isFeatureEnabled ||
        authenticationService.refreshToken != nil
    }
}
