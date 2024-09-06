import Foundation
import XCTest
import UIKit
import SwiftUI

@testable import govuk_ios

final class AnalyticsConsentViewControllerSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        let navigationController = getNavigationController()
        navigationController.overrideUserInterfaceStyle = .light
        VerifySnapshotInWindow(navigationController)
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        let navigationController = getNavigationController()
        navigationController.overrideUserInterfaceStyle = .dark
        VerifySnapshotInWindow(navigationController)
    }

    private func getNavigationController() -> UINavigationController {
        let viewModel = AnalyticsConsentContainerViewModel(
            analyticsService: nil,
            dismissAction: {}
        )
        let containerView = AnalyticsConsentContainerView(
            viewModel: viewModel
        )
        let subject = UIHostingController(rootView: containerView)
        let navigationController = UINavigationController(rootViewController: subject)
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }
}
