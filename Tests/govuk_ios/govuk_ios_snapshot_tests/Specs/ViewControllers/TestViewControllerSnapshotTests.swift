import Foundation
import XCTest
import UIKit

@testable import govuk_ios

class TestViewControllerTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        let viewModel = TestViewModel(
            color: .green,
            tabTitle: "Orange",
            primaryTitle: "Next",
            primaryAction: {},
            secondaryTitle: "Modal",
            secondaryAction: {}
        )
        let subject = TestViewController(
            viewModel: viewModel
        )
        let navigationController = UINavigationController(rootViewController: subject)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.overrideUserInterfaceStyle = .light
        VerifySnapshotInWindow(navigationController)
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        let viewModel = TestViewModel(
            color: .green,
            tabTitle: "Orange",
            primaryTitle: "Next",
            primaryAction: {},
            secondaryTitle: "Modal",
            secondaryAction: {}
        )
        let subject = TestViewController(
            viewModel: viewModel
        )
        let navigationController = UINavigationController(rootViewController: subject)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.overrideUserInterfaceStyle = .dark
        VerifySnapshotInWindow(navigationController)
    }

    func test_loadInNavigationController_withModalAction_rendersCorrectly() {
        let viewModel = TestViewModel(
            color: .green,
            tabTitle: "Orange",
            primaryTitle: "Next",
            primaryAction: {},
            secondaryTitle: nil,
            secondaryAction: nil
        )
        let subject = TestViewController(
            viewModel: viewModel
        )
        let navigationController = UINavigationController(rootViewController: subject)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.overrideUserInterfaceStyle = .light
        VerifySnapshotInWindow(navigationController)
    }
}
