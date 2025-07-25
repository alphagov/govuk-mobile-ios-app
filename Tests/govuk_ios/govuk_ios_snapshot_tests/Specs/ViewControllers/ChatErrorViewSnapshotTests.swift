import Foundation
import XCTest
import UIKit
import GOVKit

@testable import GOVKitTestUtilities
@testable import govuk_ios

@MainActor class ChatErrorViewSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        let viewModel = ChatErrorViewModel(
            error: .apiUnavailable,
            action: { },
            openURLAction: { _ in }
        )
        let chatErrorView = InfoView(viewModel: viewModel)
        let hostingViewController =  HostingViewController(
            rootView: chatErrorView,
            statusBarStyle: .darkContent
        )
        VerifySnapshotInNavigationController(
            viewController: hostingViewController,
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        let viewModel = ChatErrorViewModel(
            error: .apiUnavailable,
            action: { },
            openURLAction: { _ in }
        )
        let chatErrorView = InfoView(viewModel: viewModel)
        let hostingViewController =  HostingViewController(
            rootView: chatErrorView,
            statusBarStyle: .darkContent
        )
        VerifySnapshotInNavigationController(
            viewController: hostingViewController,
            mode: .dark,
            prefersLargeTitles: true
        )
    }
}
