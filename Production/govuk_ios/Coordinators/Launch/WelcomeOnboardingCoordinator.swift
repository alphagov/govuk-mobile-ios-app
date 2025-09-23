import Foundation
import UIKit
import SwiftUI
import GOVKit

class WelcomeOnboardingCoordinator: BaseCoordinator {
    private let navigationController: UINavigationController
    private let authenticationService: AuthenticationServiceInterface
    private let coordinatorBuilder: CoordinatorBuilder
    private let viewControllerBuilder: ViewControllerBuilder
    private let analyticsService: AnalyticsServiceInterface
    private var pendingAuthenticationCoordinator: BaseCoordinator?
    private let completionAction: () -> Void

    init(navigationController: UINavigationController,
         authenticationService: AuthenticationServiceInterface,
         coordinatorBuilder: CoordinatorBuilder,
         viewControllerBuilder: ViewControllerBuilder,
         analyticsService: AnalyticsServiceInterface,
         completionAction: @escaping () -> Void) {
        self.navigationController = navigationController
        self.authenticationService = authenticationService
        self.coordinatorBuilder = coordinatorBuilder
        self.viewControllerBuilder = viewControllerBuilder
        self.analyticsService = analyticsService
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
            completion: { [weak self] in
                self?.startAuthentication()
            }
        )
        set(viewController)
    }

    private func startAuthentication() {
        guard pendingAuthenticationCoordinator == nil else { return }
        let authenticationCoordinator = coordinatorBuilder.authentication(
            navigationController: navigationController,
            completionAction: completionAction,
            handleError: { [weak self] error in
                self?.showError(error)
            }
        )
        start(authenticationCoordinator)
        pendingAuthenticationCoordinator = authenticationCoordinator
    }

    private func showError(_ error: AuthenticationError) {
        analyticsService.track(error: error)
        pendingAuthenticationCoordinator = nil
        guard case .loginFlow(.userCancelled) = error else {
            analyticsService.track(error: error)
            setSignInError()
            return
        }
    }

    private func setSignInError() {
        let viewController = viewControllerBuilder.signInError(
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
