import Foundation
import XCTest
import SwiftUI

@testable import govuk_ios

@MainActor
final class AppUnavailableViewControllerSnapshotTests: SnapshotTestCase {
    private func view(error: AppConfigError? = nil) -> some View {
        return AppUnavailableContainerView(
            viewModel: AppUnavailableContainerViewModel(
                appLaunchService: MockAppLaunchService(),
                error: error,
                dismissAction: { }
            )
        )
    }

    func test_loadInNavigationController_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            view: view(),
            mode: .light,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            view: view(),
            mode: .dark,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_networkError_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            view: view(error: .networkUnavailable),
            mode: .light,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_networkError_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            view: view(error: .networkUnavailable),
            mode: .dark,
            navBarHidden: true
        )
    }
}
