import Foundation
import XCTest
import UIKit

@testable import govuk_ios

@MainActor
class SettingsViewControllerSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .dark,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_preview_rendersCorrectly() {
        let settingsContentView = SettingsView(
            viewModel: GroupedListViewModel()
        )
        let viewController = HostingViewController(rootView: settingsContentView)
        viewController.title = "Settings"
        viewController.navigationItem.largeTitleDisplayMode = .always
        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light,
            prefersLargeTitles: true
        )
    }

    private func viewController() -> UIViewController {
        let mockVersionProvider = MockAppVersionProvider()
        mockVersionProvider.versionNumber = "1.2.3"
        mockVersionProvider.buildNumber = "123"
        let viewModel = SettingsViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: MockURLOpener(),
            versionProvider: mockVersionProvider
        )
        let settingsContentView = SettingsView(
            viewModel: viewModel
        )
        return HostingViewController(
            rootView: settingsContentView,
            statusBarStyle: .darkContent
        )
    }
}

class GroupedListViewModel: SettingsViewModelInterface {
    var title: String = "Settings"
    var listContent: [GroupedListSection] = GroupedListSection_Previews.previewContent

    func trackScreen(screen: any govuk_ios.TrackableScreen) {
        // Do Nothing
    }
}
