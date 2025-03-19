import Foundation
import UIKit
import SwiftUI
import GOVKit

class AnalyticsConsentCoordinator: BaseCoordinator {
    private let analyticsService: AnalyticsServiceInterface
    private let dismissAction: () -> Void

    init(navigationController: UINavigationController,
         analyticsService: AnalyticsServiceInterface,
         dismissAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.dismissAction = dismissAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard analyticsService.permissionState == .unknown
        else { return dismissAction() }
        setAnalyticsConsent()
    }

    private func setAnalyticsConsent() {
        let viewModel = AnalyticsConsentContainerViewModel(
            analyticsService: analyticsService,
            dismissAction: dismissAction
        )
        let containerView = AnalyticsConsentContainerView(
            viewModel: viewModel
        )
        let viewController = UIHostingController(
            rootView: containerView
        )
        set(viewController)
    }
}
