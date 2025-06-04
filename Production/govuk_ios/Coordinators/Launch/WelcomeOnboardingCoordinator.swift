import Foundation
import UIKit
import SwiftUI
import GOVKit
import Onboarding

class WelcomeOnboardingCoordinator: BaseCoordinator {
    private let navigationController: UINavigationController
    private let authenticationService: AuthenticationServiceInterface
    private let onboardingAnalyticsService: OnboardingAnalyticsService
    private let analyticsService: AnalyticsServiceInterface
    private let coordinatorBuilder: CoordinatorBuilder
    private let viewControllerBuilder: ViewControllerBuilder
    private let completionAction: () -> Void

    init(navigationController: UINavigationController,
         authenticationService: AuthenticationServiceInterface,
         onboardingAnalyticsService: OnboardingAnalyticsService,
         analyticsService: AnalyticsServiceInterface,
         coordinatorBuilder: CoordinatorBuilder,
         viewControllerBuilder: ViewControllerBuilder,
         completionAction: @escaping () -> Void) {
        self.navigationController = navigationController
        self.authenticationService = authenticationService
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

        setWelcomeOnboardingViewController()
    }

    private func setWelcomeOnboardingViewController(_ animated: Bool = true) {
        let viewController = viewControllerBuilder.welcomeOnboarding(
            analyticsService: analyticsService,
            completion: { [weak self] in
                self?.startAuthentication()
            }
        )
        set(viewController)
    }

    private func startAuthentication() {
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
                self?.setWelcomeOnboardingViewController(false)
            }
        )
        set(viewController, animated: false)
    }

    private var shouldSkipOnboarding: Bool {
        authenticationService.isSignedIn
    }
}
