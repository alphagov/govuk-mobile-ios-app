import Foundation
import UIKit

class AnalyticsConsentCoordinator: BaseCoordinator {
    private let analyticsConsentService: AnalyticsConsentServiceInterface
    private let analyticsService: AnalyticsServiceInterface

    private let dismissAction: () -> Void

    init(navigationController: UINavigationController,
         analyticsConsentService: AnalyticsConsentServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         dismissAction: @escaping () -> Void) {
        self.analyticsConsentService = analyticsConsentService
        self.analyticsService = analyticsService
        self.dismissAction = dismissAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard !analyticsConsentService.hasSeenAnalyticsConsent
        else { return dismissAction() }
        startAnalyticsConsent()
    }

    private func startAnalyticsConsent() {
        let analyticsConsentModule = AnalyticsConsent(
            analyticsService: analyticsService,
            dismissAction: { [weak self] in
                self?.analyticsConsentService.setHasSeenAnalyticsConsent()
                self?.dismissAction()
            }
        )
        set(analyticsConsentModule.viewController)
    }
}
