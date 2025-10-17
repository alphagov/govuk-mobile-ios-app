import Foundation
import XCTest

@testable import govuk_ios

@MainActor
final class SearchSuggestionsViewControllerSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        let mockSearchService = MockSearchService()
        let mockAnalyticsService = MockAnalyticsService()

        let viewModel = SearchSuggestionsViewModel(
            searchService: mockSearchService,
            analyticsService: mockAnalyticsService
        )
        viewModel.searchBarText = "suggestion"
        viewModel.suggestions = [
            SearchSuggestion(text: "First suggestion"),
            SearchSuggestion(text: "Second suggestion"),
            SearchSuggestion(text: "Third suggestion")
        ]
        let viewController = SearchSuggestionsViewController(
            viewModel: viewModel,
            selectionAction: { _ in }
        )

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        let mockSearchService = MockSearchService()
        let mockAnalyticsService = MockAnalyticsService()

        let viewModel = SearchSuggestionsViewModel(
            searchService: mockSearchService,
            analyticsService: mockAnalyticsService
        )
        viewModel.searchBarText = "First"
        viewModel.suggestions = [
            SearchSuggestion(text: "First suggestion"),
        ]
        let viewController = SearchSuggestionsViewController(
            viewModel: viewModel,
            selectionAction: { _ in }
        )
        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .dark
        )
    }
}
