import Foundation
import UIKit
import SwiftUI
import GOVKit

class AnalyticsConsentCoordinator: BaseCoordinator {
    private let analyticsService: AnalyticsServiceInterface
    private let coordinatorBuilder: CoordinatorBuilder
    private let viewControllerBuilder: ViewControllerBuilder
    private let completion: () -> Void

    init(navigationController: UINavigationController,
         analyticsService: AnalyticsServiceInterface,
         coordinatorBuilder: CoordinatorBuilder,
         viewControllerBuilder: ViewControllerBuilder,
         completion: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.coordinatorBuilder = coordinatorBuilder
        self.viewControllerBuilder = viewControllerBuilder
        self.completion = completion
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard analyticsService.permissionState == .unknown
        else { return completion() }
        setAnalyticsConsent()
    }

    private func setAnalyticsConsent() {
        let viewController = viewControllerBuilder.analyticsConsent(
            analyticsService: analyticsService,
            completion: completion,
            viewPrivacyAction: { [weak self] in
                self?.openPrivacy()
            }
        )
        set(viewController)
    }

    private func openPrivacy() {
        let coordinator = coordinatorBuilder.safari(
            navigationController: root,
            url: Constants.API.privacyPolicyUrl,
            fullScreen: false
        )
        start(coordinator)
    }
}
