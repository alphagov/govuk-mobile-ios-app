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
        // This is here to meet code coverage requirements
        viewModel.scrollToTop = true
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

    private lazy var viewModel: SettingsViewModel = {
        let mockVersionProvider = MockAppVersionProvider()
        mockVersionProvider.versionNumber = "1.2.3"
        mockVersionProvider.buildNumber = "123"
        return SettingsViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: MockURLOpener(),
            versionProvider: mockVersionProvider
        )
    }()

    private func viewController() -> UIViewController {
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
    var listContent: [GroupedListSection] = GroupedListSection_Previews.previewContent.dropLast()
    var scrollToTop: Bool = false

    func trackScreen(screen: any govuk_ios.TrackableScreen) {
        // Do Nothing
    }
}
