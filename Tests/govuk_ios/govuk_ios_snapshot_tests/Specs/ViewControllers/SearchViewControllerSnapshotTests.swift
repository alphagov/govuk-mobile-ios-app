import Foundation
import XCTest
import UIKit

@testable import govuk_ios

@MainActor
class SearchViewControllerSnapshotTests: SnapshotTestCase {
    func test_search_successResponse_withResults_rendersCorrectly() {
        let url = URL(string: "https://www.gov.uk")!
        let result = SearchResult(
            results: [
                SearchItem(title: "Test 1",
                           description: "Description 1",
                           contentId: nil,
                           link: url),
                SearchItem(title: "Test 2",
                           description: "Description 2",
                           contentId: UUID().uuidString,
                           link: url),
                SearchItem(title: "Test 3",
                           description: nil,
                           contentId: UUID().uuidString,
                           link: url)
            ]
        )
        let viewController = createViewController(result: .success(result))
        viewController.viewDidLoad()
        searchBar.searchTextField.text = "With results"
        let _ = viewController.textFieldShouldReturn(searchBar.searchTextField)
        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light
        )
    }

    func test_search_successResponse_withResults_dark_rendersCorrectly() {
        let url = URL(string: "https://www.gov.uk")!
        let result = SearchResult(
            results: [
                SearchItem(title: "Test 1",
                           description: "Description 1",
                           contentId: UUID().uuidString,
                           link: url)
            ]
        )
        let viewController = createViewController(result: .success(result))
        viewController.viewDidLoad()
        searchBar.searchTextField.text = "Dark mode with results"
        let _ = viewController.textFieldShouldReturn(searchBar.searchTextField)
        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .dark
        )
    }

    func test_search_successResponse_noResults_rendersCorrectly() {
        let viewController = createViewController(result: .failure(.noResults))
        viewController.viewDidLoad()
        searchBar.searchTextField.text = "No results"
        let _ = viewController.textFieldShouldReturn(searchBar.searchTextField)
        viewController.view.layoutSubviews()
        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light
        )
    }

    func test_search_failureResponse_genericError_rendersCorrectly() {
        let viewController = createViewController(result: .failure(.apiUnavailable))
        viewController.viewDidLoad()
        searchBar.searchTextField.text = "Generic error"
        let _ = viewController.textFieldShouldReturn(searchBar.searchTextField)
        viewController.view.layoutSubviews()
        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light
        )
    }

    func test_search_failureResponse_networkUnavailable_rendersCorrectly() {
        let viewController = createViewController(result: .failure(.networkUnavailable))
        viewController.viewDidLoad()
        searchBar.searchTextField.text = "Network unavailable"
        let _ = viewController.textFieldShouldReturn(searchBar.searchTextField)
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
            urlOpener: MockURLOpener(),
            openAction: { _ in }
        )
        return SearchViewController(
            viewModel: viewModel,
            searchBar: searchBar
        )
    }
    let searchBar = UISearchBar()
}
