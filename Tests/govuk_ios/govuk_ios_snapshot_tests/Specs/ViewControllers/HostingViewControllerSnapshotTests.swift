import Foundation
import UIKit
import SwiftUI
import CoreData

@testable import govuk_ios

class HostingViewControllerSnapshotTests: SnapshotTestCase {

    func test_loadInNavigationController_hiddenNavbar_light_rendersCorrectly() {
        let view = Text("Test")
        let viewController = HostingViewController(
            rootView: view,
            navigationBarHidden: true
        )
        viewController.title = "Title"

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_showNavbar_light_rendersCorrectly() {
        let view = Text("Test")
        let viewController = HostingViewController(
            rootView: view,
            navigationBarHidden: false
        )
        viewController.title = "Title"

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light,
            navBarHidden: true
        )
    }


}
