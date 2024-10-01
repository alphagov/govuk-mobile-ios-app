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
        guard appConfigService.isFeatureEnabled(key: .onboarding) &&
                !onboardingService.hasSeenOnboarding
        else { return dismissAction() }
        setOnboarding()
    }

    private func setOnboarding() {
        let slides = onboardingService.fetchSlides()
        let onboardingModule = Onboarding(
            source: .model(slides),
            analyticsService: analyticsService,
            dismissAction: { [weak self] in
                self?.onboardingService.setHasSeenOnboarding()
                self?.dismissAction()
            }
        )
        set(onboardingModule.viewController)
    }
}
