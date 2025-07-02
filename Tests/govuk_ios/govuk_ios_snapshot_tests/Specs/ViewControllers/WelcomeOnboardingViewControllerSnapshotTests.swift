import Foundation
import XCTest
import UIKit
import GOVKit

@testable import GOVKitTestUtilities
@testable import govuk_ios

class WelcomeOnboardingViewControllerSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        let viewModel = WelcomeOnboardingViewModel(
            analyticsService: MockAnalyticsService(),
            completeAction: { }
        )
        let welcomeOnboardingView = WelcomeOnboardingView(viewModel: viewModel)
        let hostingViewController =  HostingViewController(
            rootView: welcomeOnboardingView,
            statusBarStyle: .darkContent
        )
        VerifySnapshotInNavigationController(
            viewController: hostingViewController,
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        let viewModel = WelcomeOnboardingViewModel(
            analyticsService: MockAnalyticsService(),
            completeAction: { }
        )
        let welcomeOnboardingView = WelcomeOnboardingView(viewModel: viewModel)
        let hostingViewController =  HostingViewController(
            rootView: welcomeOnboardingView,
            statusBarStyle: .darkContent
        )
        VerifySnapshotInNavigationController(
            viewController: hostingViewController,
            mode: .dark,
            prefersLargeTitles: true
        )
    }
}
