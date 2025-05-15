import Foundation
import XCTest
import GOVKit

@testable import GOVKitTestUtilities
@testable import govuk_ios

@MainActor
class NotificationsOnboardingViewSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        let viewModel = NotificationsOnboardingViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: MockAnalyticsService(),
            completeAction: { },
            dismissAction: { }
        )
        let view = NotificationsOnboardingView(viewModel: viewModel)
        let viewController = HostingViewController(rootView: view)

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        let viewModel = NotificationsOnboardingViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: MockAnalyticsService(),
            completeAction: { },
            dismissAction: { }
        )
        let view = NotificationsOnboardingView(viewModel: viewModel)
        let viewController = HostingViewController(rootView: view)

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .dark,
            navBarHidden: true
        )
    }
}
