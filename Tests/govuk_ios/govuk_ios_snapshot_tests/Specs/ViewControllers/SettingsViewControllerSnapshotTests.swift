import Foundation
import XCTest
import UIKit

@testable import govuk_ios

@MainActor
class SettingsViewControllerSnapshotTests: SnapshotTestCase {
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
    
    func test_loadInNavigationController_preview_rendersCorrectly() {
        let viewController = SettingsViewController(
            viewModel: GroupedListViewModel()
        )
        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light
        )
    }

    private func viewController() -> SettingsViewController {
        let viewModel = SettingsViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: MockURLOpener(),
            bundle: .main
        )
        return SettingsViewController(viewModel: viewModel)
    }
}

struct GroupedListViewModel: SettingsViewModelInterface {
    var title: String = "Settings"
    var listContent: [GroupedListSection] = GroupedListSection_Previews.previewContent
}
