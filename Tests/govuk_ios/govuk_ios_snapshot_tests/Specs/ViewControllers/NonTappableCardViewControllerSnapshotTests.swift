import Foundation
import XCTest
import SwiftUI

@testable import govuk_ios

@MainActor
final class NonTappableCardViewControllerSnapshotTests: SnapshotTestCase {
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
        return NonTappableCardView(
            text: "This is a card to present text content that cannot be tapped or interacted with."
        )
    }
}

