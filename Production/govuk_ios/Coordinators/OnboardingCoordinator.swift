import Foundation
import UIKit
import Onboarding

class OnboardingCoordinator: BaseCoordinator {
    private let onboardingService: OnboardingServiceInterface
    private let analyticsService: OnboardingAnalyticsService
    private let dismissAction: () -> Void

    init(navigationController: UINavigationController,
         onboardingService: OnboardingServiceInterface,
         analyticsService: OnboardingAnalyticsService,
         dismissAction: @escaping () -> Void) {
        self.dismissAction = dismissAction
        self.onboardingService = onboardingService
        self.analyticsService = analyticsService
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard !onboardingService.hasSeenOnboarding
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
