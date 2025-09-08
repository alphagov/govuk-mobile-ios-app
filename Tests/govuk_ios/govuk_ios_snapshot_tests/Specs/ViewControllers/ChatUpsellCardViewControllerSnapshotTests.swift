import Foundation
import XCTest
import UIKit
import GOVKit

@testable import govuk_ios
@testable import GOVKitTestUtilities

@MainActor
final class ChatUpsellCardViewControllerSnapshotTests: SnapshotTestCase {

    func test_loadInNavigationController_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .light
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .dark
        )
    }

    private func viewController() -> UIViewController {
        let view = ChatUpsellCard(dismissAction: {}, linkAction: {})
        return HostingViewController(rootView: view)
    }
}
