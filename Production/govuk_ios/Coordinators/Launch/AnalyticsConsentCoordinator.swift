import Foundation
import UIKit
import SwiftUI
import GOVKit

class AnalyticsConsentCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let analyticsService: AnalyticsServiceInterface
    private let completion: () -> Void

    init(navigationController: UINavigationController,
         coordinatorBuilder: CoordinatorBuilder,
         analyticsService: AnalyticsServiceInterface,
         completion: @escaping () -> Void) {
        self.coordinatorBuilder = coordinatorBuilder
        self.analyticsService = analyticsService
        self.completion = completion
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard analyticsService.permissionState == .unknown
        else { return completion() }
        setAnalyticsConsent()
    }

    private func presentWebView(url: URL) {
        let coordinator = coordinatorBuilder.safari(
            navigationController: root,
            url: url,
            fullScreen: true
        )
        start(coordinator, url: url)
    }

    private func setAnalyticsConsent() {
        let viewModel = AnalyticsConsentContainerViewModel(
            analyticsService: analyticsService,
            openAction: presentWebView(url:),
            completion: completion,
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
