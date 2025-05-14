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
    private let newUserAction: (() -> Void)?

    init(navigationController: UINavigationController,
         authenticationService: AuthenticationServiceInterface,
         authenticationOnboardingService: AuthenticationOnboardingServiceInterface,
         analyticsService: OnboardingAnalyticsService,
         coordinatorBuilder: CoordinatorBuilder,
         completionAction: @escaping () -> Void,
         newUserAction: (() -> Void)?) {
        self.navigationController = navigationController
        self.authenticationService = authenticationService
        self.authenticationOnboardingService = authenticationOnboardingService
        self.analyticsService = analyticsService
        self.coordinatorBuilder = coordinatorBuilder
        self.completionAction = completionAction
        self.newUserAction = newUserAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard !shouldSkipOnboarding else {
            finishCoordination()
            return
        }

        setOnboarding()
    }

    private func setOnboarding(_ animated: Bool = true) {
        let onboardingModule = Onboarding(
            slideProvider: authenticationOnboardingService,
            analyticsService: analyticsService,
            completeAction: { [weak self] in
                Task {
                    await self?.authenticateAction()
                }
            },
            dismissAction: { }
        )
        set(
            onboardingModule.viewController,
            animated: animated
        )
    }

    private func finishCoordination() {
        DispatchQueue.main.async {
            self.completionAction()
        }
    }

    private func authenticateAction() async {
        let authenticationCoordinator = coordinatorBuilder.authentication(
            navigationController: navigationController,
            completionAction: completionAction,
            newUserAction: newUserAction,
            handleError: showError
        )
        start(authenticationCoordinator)
    }

    func showError(_ error: AuthenticationError) {
        guard case .loginFlow(.userCancelled) = error else {
            let errorCoordinator = coordinatorBuilder.signInError(
                navigationController: root,
                completion: { [weak self] in
                    self?.setOnboarding(false)
                }
            )
            start(errorCoordinator)
            return
        }
    }

    private var shouldSkipOnboarding: Bool {
        !authenticationOnboardingService.isFeatureEnabled ||
        authenticationService.isSignedIn
    }
}
