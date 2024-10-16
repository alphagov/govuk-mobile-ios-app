import Foundation
import XCTest
import UIKit

@testable import govuk_ios

@MainActor
class SearchViewControllerSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        let viewController = createViewController(result: nil)
        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        let viewController = createViewController(result: nil)
        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .dark
        )
    }

    func test_search_successResponse_withResults_rendersCorrectly() {
        let result = SearchResult(
            results: [
                .arrange(title: "Test 1", description: "Description 1"),
                .arrange(title: "Test 2", description: "Description 2"),
            ]
        )
        let viewController = createViewController(result: .success(result))
        viewController.viewDidLoad()
        let searchBar = viewController.view.subviews.compactMap { $0 as? UISearchBar }.first
        searchBar?.searchTextField.text = "Test with results"
        searchBar?.searchTextField.sendActions(for: .editingDidEndOnExit)
        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light
        )
    }

    func test_search_successResponse_noResults_rendersCorrectly() {
        let viewController = createViewController(result: .failure(.noResults))
        viewController.viewDidLoad()
        let searchBar = viewController.view.subviews.compactMap { $0 as? UISearchBar }.first
        searchBar?.searchTextField.text = "Empty results"
        searchBar?.searchTextField.sendActions(for: .editingDidEndOnExit)
        viewController.view.layoutSubviews()
        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light
        )
    }

    func test_search_failureResponse_genericError_rendersCorrectly() {
        let viewController = createViewController(result: .failure(.apiUnavailable))
        viewController.viewDidLoad()
        let searchBar = viewController.view.subviews.compactMap { $0 as? UISearchBar }.first
        searchBar?.searchTextField.text = "Generic error"
        searchBar?.searchTextField.sendActions(for: .editingDidEndOnExit)
        viewController.view.layoutSubviews()
        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light
        )
    }

    func test_search_failureResponse_networkUnavailable_rendersCorrectly() {
        let viewController = createViewController(result: .failure(.networkUnavailable))
        viewController.viewDidLoad()
        let searchBar = viewController.view.subviews.compactMap { $0 as? UISearchBar }.first
        searchBar?.searchTextField.text = "Network unavailable"
        searchBar?.searchTextField.sendActions(for: .editingDidEndOnExit)
        viewController.view.layoutSubviews()
        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light
        )
    }

    private func createViewController(result: Result<SearchResult, SearchError>?) -> SearchViewController {
        let mockSearchService = MockSearchService()
        mockSearchService._stubbedSearchResult = result
        let viewModel = SearchViewModel(
            analyticsService: MockAnalyticsService(),
            searchService: mockSearchService,
            activityService: MockActivityService(),
            urlOpener: MockURLOpener()
        )
        return SearchViewController(
            viewModel: viewModel,
            dismissAction: {}
        )
    }
}
