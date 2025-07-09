import Foundation
import XCTest
import GOVKit
import UIKit

@testable import GOVKitTestUtilities
@testable import govuk_ios

@MainActor
final class LocalAuthorityPostcodeEntryViewControllerSnapshotTests: SnapshotTestCase {
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

    func test_loadInNavigationController_error_light_rendersCorrectly() {

        let viewModel = LocalAuthorityPostcodeEntryViewModel(
            service: MockLocalAuthorityService(),
            analyticsService: MockAnalyticsService(),
            resolveAmbiguityAction: { _, _ in },
            localAuthoritySelected: {_ in },
            dismissAction: {}
        )
        let view = LocalAuthorityPostcodeEntryView(
            viewModel: viewModel
        )
        viewModel.postCode = ""
        viewModel.primaryButtonViewModel.action()
        VerifySnapshotInNavigationController(
            viewController: HostingViewController(rootView: view),
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_error_dark_rendersCorrectly() {

        let viewModel = LocalAuthorityPostcodeEntryViewModel(
            service: MockLocalAuthorityService(),
            analyticsService: MockAnalyticsService(),
            resolveAmbiguityAction: { _, _ in },
            localAuthoritySelected: {_ in },
            dismissAction: {}
        )
        let view = LocalAuthorityPostcodeEntryView(
            viewModel: viewModel
        )
        viewModel.postCode = ""
        viewModel.primaryButtonViewModel.action()
        VerifySnapshotInNavigationController(
            viewController: HostingViewController(rootView: view),
            mode: .dark,
            prefersLargeTitles: true
        )
    }

    private func viewController() -> UIViewController {
        let viewModel = LocalAuthorityPostcodeEntryViewModel(
            service: MockLocalAuthorityService(),
            analyticsService: MockAnalyticsService(),
            resolveAmbiguityAction: { _, _ in },
            localAuthoritySelected: {_ in },
            dismissAction: {}
        )
        let view = LocalAuthorityPostcodeEntryView(
            viewModel: viewModel
        )
        return HostingViewController(rootView: view)
    }
}


