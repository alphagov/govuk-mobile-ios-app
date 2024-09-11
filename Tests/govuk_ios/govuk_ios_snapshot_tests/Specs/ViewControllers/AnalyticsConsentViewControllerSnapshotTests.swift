import Foundation
import XCTest
import SwiftUI

@testable import govuk_ios

final class AnalyticsConsentViewControllerSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        loadInNavigationControllerTest(view: view, navBarHidden: true)
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        loadInNavigationControllerTest(view: view, mode: .dark, navBarHidden: true)
    }

    private var view: some View {
        let viewModel = AnalyticsConsentContainerViewModel(
            analyticsService: nil,
            dismissAction: {}
        )
        return AnalyticsConsentContainerView(
            viewModel: viewModel
        )
    }
}