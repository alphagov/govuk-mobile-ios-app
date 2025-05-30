import Foundation
import UIKit
import Onboarding
import GOVKit

class AuthenticationOnboardingCoordinator: BaseCoordinator {
    private let navigationController: UINavigationController
    private let authenticationService: AuthenticationServiceInterface
    private let authenticationOnboardingService: AuthenticationOnboardingServiceInterface
    private let onboardingAnalyticsService: OnboardingAnalyticsService
    private let analyticsService: AnalyticsServiceInterface
    private let coordinatorBuilder: CoordinatorBuilder
    private let viewControllerBuilder: ViewControllerBuilder
    private let completionAction: () -> Void

    init(navigationController: UINavigationController,
         authenticationService: AuthenticationServiceInterface,
         authenticationOnboardingService: AuthenticationOnboardingServiceInterface,
         onboardingAnalyticsService: OnboardingAnalyticsService,
         analyticsService: AnalyticsServiceInterface,
         coordinatorBuilder: CoordinatorBuilder,
         viewControllerBuilder: ViewControllerBuilder,
         completionAction: @escaping () -> Void) {
        self.navigationController = navigationController
        self.authenticationService = authenticationService
        self.authenticationOnboardingService = authenticationOnboardingService
        self.onboardingAnalyticsService = onboardingAnalyticsService
        self.analyticsService = analyticsService
        self.coordinatorBuilder = coordinatorBuilder
        self.viewControllerBuilder = viewControllerBuilder
        self.completionAction = completionAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard !shouldSkipOnboarding
        else { return completionAction() }

        setOnboarding()
    }

    private func setOnboarding(_ animated: Bool = true) {
        let onboardingModule = Onboarding(
            slideProvider: authenticationOnboardingService,
            analyticsService: onboardingAnalyticsService,
            completeAction: { [weak self] in
                Task {
                    await self?.startAuthentication()
                }
            },
            dismissAction: { }
        )
        set(
            onboardingModule.viewController,
            animated: animated
        )
    }

    private func startAuthentication() async {
        let authenticationCoordinator = coordinatorBuilder.authentication(
            navigationController: navigationController,
            completionAction: completionAction,
            handleError: showError
        )
        start(authenticationCoordinator)
    }

    private func showError(_ error: AuthenticationError) {
        guard case .loginFlow(.userCancelled) = error else {
            setSignInError()
            return
        }
    }

    private func setSignInError() {
        let viewController = viewControllerBuilder.signInError(
            analyticsService: analyticsService,
            completion: { [weak self] in
                self?.setOnboarding(false)
            }
        )
        set(viewController, animated: false)
    }

    private var shouldSkipOnboarding: Bool {
        !authenticationOnboardingService.isFeatureEnabled ||
        authenticationService.isSignedIn
    }
}
