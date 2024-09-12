import Foundation
import XCTest
import UIKit

@testable import govuk_ios

class SettingsViewControllerSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        loadInNavigationControllerTest(viewController: viewController(),
                                       navBarHidden: true)
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        loadInNavigationControllerTest(viewController: viewController(),
                                       mode: .dark,
                                       navBarHidden: true)
    }
    
    func test_loadInNavigationController_preview_rendersCorrectly() {
        let viewController = SettingsViewController(viewModel: GroupedListViewModel())
        loadInNavigationControllerTest(viewController: viewController,
                                       navBarHidden: true)
    }

    private func viewController() -> SettingsViewController {
        let viewModel = SettingsViewModel()
        return SettingsViewController(viewModel: viewModel)
    }
}

struct GroupedListViewModel: SettingsViewModelProtocol {
    var title: String = "Settings"
    var listContent: [GroupedListSection] = GroupedListSection_Previews.previewContent
}
