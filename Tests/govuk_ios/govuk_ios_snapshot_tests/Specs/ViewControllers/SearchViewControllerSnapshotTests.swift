import Foundation
import XCTest
import UIKit

@testable import govuk_ios

@MainActor
class SearchViewControllerSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .dark
        )
    }

    private var viewController: SearchViewController {
        let viewModel = SearchViewModel(
            analyticsService: MockAnalyticsService(),
            searchService: MockSearchService(),
            urlOpener: MockURLOpener()
        )
        return SearchViewController(
            viewModel: viewModel,
            dismissAction: {}
        )
    }
}
