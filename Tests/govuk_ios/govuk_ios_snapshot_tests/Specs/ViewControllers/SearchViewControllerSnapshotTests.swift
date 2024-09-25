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
        let result = SearchResult(results: [
            .init(title: "Test 1", description: "Description 1", link: ""),
            .init(title: "Test 2", description: "Description 2", link: ""),
        ])
        let viewController = createViewController(result: .success(result))
        viewController.viewDidLoad()
        let searchBar = viewController.view.subviews.compactMap { $0 as? UISearchBar  }.first
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
        let searchBar = viewController.view.subviews.compactMap { $0 as? UISearchBar  }.first
        searchBar?.searchTextField.text = "Empty results"
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
            urlOpener: MockURLOpener()
        )
        return SearchViewController(
            viewModel: viewModel,
            dismissAction: {}
        )
    }
}
