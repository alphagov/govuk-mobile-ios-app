import Foundation
import XCTest
import GOVKit
import UIKit

@testable import govuk_ios

@MainActor
final class LocalAuthorityConfirmationViewControllerSnapshotTests: SnapshotTestCase {

    func test_loadInNavigationController_unitary_light_rendersCorrectly() {
        let authority = Authority(
            name: "Test",
            homepageUrl: "Test",
            tier: "unitary",
            slug: "test slug",
            parent: nil
        )
        let viewModel = LocalAuthorityConfirmationViewModel(
            analyticsService: MockAnalyticsService(),
            localAuthorityItem: authority,
            completion: {}
        )
        let view = LocalAuthorityConfirmationView(
            viewModel: viewModel
        )

        VerifySnapshotInNavigationController(
            viewController: HostingViewController(rootView: view),
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_unitary_dark_rendersCorrectly() {
        let authority = Authority(
            name: "Test",
            homepageUrl: "Test",
            tier: "unitary",
            slug: "test slug",
            parent: nil
        )
        let viewModel = LocalAuthorityConfirmationViewModel(
            analyticsService: MockAnalyticsService(),
            localAuthorityItem: authority,
            completion: {}
        )
        let view = LocalAuthorityConfirmationView(
            viewModel: viewModel
        )
        VerifySnapshotInNavigationController(
            viewController: HostingViewController(rootView: view),
            mode: .dark,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_twoTier_light_rendersCorrectly() {
        let parentAuthority = Authority(
            name: "Test parent",
            homepageUrl: "Test parent",
            tier: "unitary parent",
            slug: "test slug",
            parent: nil
        )
        let authority = Authority(
            name: "Test",
            homepageUrl: "Test",
            tier: "unitary",
            slug: "test slug",
            parent: parentAuthority
        )
        let viewModel = LocalAuthorityConfirmationViewModel(
            analyticsService: MockAnalyticsService(),
            localAuthorityItem: authority,
            completion: {}
        )
        let view = LocalAuthorityConfirmationView(
            viewModel: viewModel
        )
        VerifySnapshotInNavigationController(
            viewController: HostingViewController(rootView: view),
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_twoTier_dark_rendersCorrectly() {
        let parentAuthority = Authority(
            name: "Test parent",
            homepageUrl: "Test parent",
            tier: "unitary parent",
            slug: "test slug",
            parent: nil
        )
        let authority = Authority(
            name: "Test",
            homepageUrl: "Test",
            tier: "unitary",
            slug: "test slug",
            parent: parentAuthority
        )
        let viewModel = LocalAuthorityConfirmationViewModel(
            analyticsService: MockAnalyticsService(),
            localAuthorityItem: authority,
            completion: {}
        )
        let view = LocalAuthorityConfirmationView(
            viewModel: viewModel
        )
        VerifySnapshotInNavigationController(
            viewController: HostingViewController(rootView: view),
            mode: .dark,
            prefersLargeTitles: true
        )
    }
}


