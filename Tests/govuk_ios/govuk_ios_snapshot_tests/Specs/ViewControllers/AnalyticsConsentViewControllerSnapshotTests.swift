import Foundation
import XCTest
import SwiftUI

@testable import govuk_ios

@MainActor
final class AnalyticsConsentViewControllerSnapshotTests: SnapshotTestCase {
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

    private var view: some View {
        let viewModel = AnalyticsConsentContainerViewModel(
            analyticsService: nil,
            completion: { },
            viewPrivacyAction: { }
        )
        return AnalyticsConsentContainerView(
            viewModel: viewModel
        )
    }
}
