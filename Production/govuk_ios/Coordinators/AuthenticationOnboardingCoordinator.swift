import Foundation
import UIKit
import Onboarding

class AuthenticationOnboardingCoordinator: BaseCoordinator {
    private let analyticsService: OnboardingAnalyticsService
    private let authenticationService: AuthenticationServiceInterface
    private let authenticationOnboardingService: AuthenticationOnboardingServiceInterface
    private let completeAction: () -> Void

    init(navigationController: UINavigationController,
         analyticsService: OnboardingAnalyticsService,
         authenticationService: AuthenticationServiceInterface,
         authenticationOnboardingService: AuthenticationOnboardingServiceInterface,
         completionAction: @escaping () -> Void) {
        self.authenticationService = authenticationService
        self.authenticationOnboardingService = authenticationOnboardingService
        self.analyticsService = analyticsService
        self.completeAction = completionAction
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
            self.completeAction()
        }
    }

    private func authenticateAction() async {
        guard let window = UIApplication.shared.window else {
            return
        }

        await authenticationService.authenticate(
            window: window,
            completion: { [weak self] result in
                switch result {
                case .success(let response):
                    print("\(response)")
                    self?.finishCoordination()
                case .failure(let error):
                    print("\(error)")
                }
            }
        )
    }
}
