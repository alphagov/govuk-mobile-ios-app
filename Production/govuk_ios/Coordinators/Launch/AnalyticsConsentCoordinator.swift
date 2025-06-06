import Foundation
import UIKit
import SwiftUI
import GOVKit

class AnalyticsConsentCoordinator: BaseCoordinator {
    private let analyticsService: AnalyticsServiceInterface
    private let completion: () -> Void

    init(navigationController: UINavigationController,
         analyticsService: AnalyticsServiceInterface,
         completion: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.completion = completion
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard analyticsService.permissionState == .unknown
        else { return completion() }
        setAnalyticsConsent()
    }

    private func setAnalyticsConsent() {
        let viewModel = AnalyticsConsentContainerViewModel(
            analyticsService: analyticsService,
            completion: completion
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
