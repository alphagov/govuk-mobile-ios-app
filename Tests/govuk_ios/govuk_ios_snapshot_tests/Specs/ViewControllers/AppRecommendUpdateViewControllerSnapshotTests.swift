import Foundation
import XCTest
import SwiftUI

@testable import govuk_ios

@MainActor
final class AppRecommendUpdateViewControllerSnapshotTests: SnapshotTestCase {
    private var view: some View {
        return AppRecommendUpdateContainerView(
            viewModel: AppRecommendUpdateContainerViewModel(dismissAction: {})
        )
    }

    func test_loadInNavigationController_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            view: view,
            mode: .light,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            view: view,
            mode: .dark,
            navBarHidden: true
        )
    }
}
