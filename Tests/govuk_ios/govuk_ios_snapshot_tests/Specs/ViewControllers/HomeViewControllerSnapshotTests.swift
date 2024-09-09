import Foundation
import XCTest
import UIKit

@testable import govuk_ios

class HomeViewControllerSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        loadInNavigationControllerTest(viewController: viewController,
                                       navBarHidden: true)
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        loadInNavigationControllerTest(viewController: viewController,
                                       mode: .dark,
                                       navBarHidden: true)
    }

    private var viewController: HomeViewController {
        let viewModel = HomeViewModel(configService: MockAppConfigService(),
                                      searchButtonPrimaryAction: { })
        return HomeViewController(viewModel: viewModel)
    }
}
