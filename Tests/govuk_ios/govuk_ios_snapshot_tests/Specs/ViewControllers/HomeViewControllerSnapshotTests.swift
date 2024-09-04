import Foundation
import XCTest
import UIKit

@testable import govuk_ios

class HomeViewControllerSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        let viewModel = HomeViewModel(
            configService: MockAppConfigService(),
            searchButtonPrimaryAction: { () -> Void in }
        )
        let subject = HomeViewController(
            viewModel: viewModel
        )
        let navigationController = UINavigationController(rootViewController: subject)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.overrideUserInterfaceStyle = .light
        VerifySnapshotInWindow(navigationController)
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        let viewModel = HomeViewModel(
            configService: MockAppConfigService(),
            searchButtonPrimaryAction: { () -> Void in }
        )
        let subject = HomeViewController(
            viewModel: viewModel
        )
        let navigationController = UINavigationController(rootViewController: subject)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.overrideUserInterfaceStyle = .dark
        VerifySnapshotInWindow(navigationController)
    }
}
