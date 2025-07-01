import Foundation
import XCTest
import UIKit
import WebKit

@testable import govuk_ios

@MainActor
class WebViewControllerSnapshotTests: SnapshotTestCase {

    func test_loadInNavigationController_light_rendersCorrectly() {
        let testURL = URL(string: "https://www.gov.uk")!
        let viewController = WebViewController(url: testURL)

        viewController.loadViewIfNeeded()

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light,
            navBarHidden: false
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        let testURL = URL(string: "https://www.gov.uk")!
        let viewController = WebViewController(url: testURL)

        viewController.loadViewIfNeeded()

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .dark,
            navBarHidden: false
        )
    }

    func test_loadInNavigationController_withCustomTitle_rendersCorrectly() {
        let testURL = URL(string: "https://www.gov.uk")!
        let viewController = WebViewController(url: testURL)
        viewController.title = "GOV.UK Web Page"

        viewController.loadViewIfNeeded()

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light,
            navBarHidden: false
        )
    }
}
