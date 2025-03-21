import Foundation
import UIKit
import Onboarding

class OnboardingCoordinator: BaseCoordinator {
    private let onboardingService: OnboardingServiceInterface
    private let analyticsService: OnboardingAnalyticsService
    private let appConfigService: AppConfigServiceInterface
    private let dismissAction: () -> Void

    init(navigationController: UINavigationController,
         onboardingService: OnboardingServiceInterface,
         analyticsService: OnboardingAnalyticsService,
         appConfigService: AppConfigServiceInterface,
         dismissAction: @escaping () -> Void) {
        self.onboardingService = onboardingService
        self.analyticsService = analyticsService
        self.appConfigService = appConfigService
        self.dismissAction = dismissAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard shouldShowOnboarding
        else { return dismissAction() }
        setOnboarding()
    }

    private var shouldShowOnboarding: Bool {
        appConfigService.isFeatureEnabled(key: .onboarding) &&
        !onboardingService.hasSeenOnboarding
    }

    private func setOnboarding() {
        let onboardingModule = Onboarding(
            slideProvider: onboardingService,
            analyticsService: analyticsService,
            completeAction: dismissOnboarding,
            dismissAction: dismissOnboarding
        )
        set(onboardingModule.viewController)
    }

    private var dismissOnboarding: () -> Void {
        { [weak self] in
            self?.onboardingService.setHasSeenOnboarding()
            self?.dismissAction()
        }
    }
}
