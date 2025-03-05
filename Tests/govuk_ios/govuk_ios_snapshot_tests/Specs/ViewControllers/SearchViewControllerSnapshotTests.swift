import Foundation
import XCTest
import UIKit

@testable import GOVKitTestUtilities
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
        let url = URL(string: "https://www.gov.uk")!
        let result = SearchResult(
            results: [
                SearchItem(title: "Test 1", description: "Description 1", link: url),
                SearchItem(title: "Test 2", description: "Description 2", link: url),
                SearchItem(title: "Test 3", description: nil, link: url)
            ]
        )
        let viewController = createViewController(result: .success(result))
        viewController.viewDidLoad()
        let searchBar = viewController.view.subviews.compactMap { $0 as? UISearchBar }.first
        let textField = searchBar!.searchTextField
        textField.text = "Test with results"
        let _ = viewController.textFieldShouldReturn(textField)

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light
        )
    }

    func test_search_successResponse_noResults_rendersCorrectly() {
        let viewController = createViewController(result: .failure(.noResults))
        viewController.viewDidLoad()
        let searchBar = viewController.view.subviews.compactMap { $0 as? UISearchBar }.first
        let textField = searchBar!.searchTextField
        textField.text = "Empty results"
        let _ = viewController.textFieldShouldReturn(textField)
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
        let textField = searchBar!.searchTextField
        textField.text = "Generic error"
        let _ = viewController.textFieldShouldReturn(textField)
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
        let textField = searchBar!.searchTextField
        textField.text = "Network unavailable"
        let _ = viewController.textFieldShouldReturn(textField)
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
            searchBar: UISearchBar()
        )
    }
}
