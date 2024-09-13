import Foundation
import XCTest
import UIKit

@testable import govuk_ios

class SearchViewControllerSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        loadInNavigationControllerTest(
            viewController: viewController,
            mode: .light
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        loadInNavigationControllerTest(
            viewController: viewController,
            mode: .dark
        )
    }

    private var viewController: SearchViewController {
        let viewModel = SearchViewModel(analyticsService: MockAnalyticsService())
        return SearchViewController(
            viewModel: viewModel,
            dismissAction: {}
        )
    }
}
