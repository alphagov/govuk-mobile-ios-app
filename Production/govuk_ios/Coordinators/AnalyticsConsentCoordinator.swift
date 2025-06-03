import Foundation
import UIKit
import SwiftUI
import GOVKit

class AnalyticsConsentCoordinator: BaseCoordinator {
    private let analyticsService: AnalyticsServiceInterface
    private let displayInModal: Bool
    private let dismissAction: () -> Void

    init(navigationController: UINavigationController,
         analyticsService: AnalyticsServiceInterface,
         displayInModal: Bool,
         dismissAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.displayInModal = displayInModal
        self.dismissAction = dismissAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard analyticsService.permissionState == .unknown
        else { return dismissAction() }
        setAnalyticsConsent()
    }

    private func setAnalyticsConsent() {
        let dismissAction = dismissAction
        let viewModel = AnalyticsConsentContainerViewModel(
            analyticsService: analyticsService,
            dismissAction: { dismissAction() }
        )
        let containerView = AnalyticsConsentContainerView(
            viewModel: viewModel
        )
        let viewController = UIHostingController(
            rootView: containerView
        )
        if displayInModal {
            viewController.isModalInPresentation = true
            root.present(viewController, animated: true)
        } else {
            set(viewController)
        }
    }
}
