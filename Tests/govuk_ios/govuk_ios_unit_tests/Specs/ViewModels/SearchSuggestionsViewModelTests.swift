import Foundation
import Testing

@testable import GOVKitTestUtilities
@testable import govuk_ios

@Suite
class SearchSuggestionsViewModelTests {
    private let mockSearchService = MockSearchService()
    private lazy var subject = SearchSuggestionsViewModel(
        searchService: mockSearchService, analyticsService: MockAnalyticsService()
    )

    @Test
    func suggestions_sets_searchSuggestions() {
        subject.searchBarText = "cat"
        subject.suggestions(
            completion: {}
        )
        let stubbedResponse = [
            "category",
            "catchment",
            "cat or dog"
        ]
        mockSearchService._suggestionsReceivedCompletion?(stubbedResponse)

        #expect(subject.suggestions.count == stubbedResponse.count)
        #expect((subject.suggestions as Any) is [SearchSuggestion])
        #expect(subject.suggestions.first?.text == "category")
    }

    @Test
    func suggestions_noResults_setsEmptySuggestions() {
        subject.searchBarText = "cat"
        subject.suggestions(
            completion: {}
        )
        let stubbedResponse: [String] = []
        mockSearchService._suggestionsReceivedCompletion?(stubbedResponse)

        #expect(subject.suggestions == [])
    }

    @Test
    func suggestions_searchBarTextEmpty_setsEmptySuggestions() {
        subject.searchBarText = ""
        subject.suggestions(
            completion: {}
        )

        #expect(mockSearchService._suggestionsReceivedTerm == nil)
        #expect(subject.suggestions == [])
    }

    @Test
    func clearSuggestions_emptiesSuggestions() {
        subject.suggestions = [SearchSuggestion(text: UUID().uuidString)]
        subject.clearSuggestions()

        #expect(subject.suggestions == [])
    }

    @Test
    func highlightedSuggestion_returns_hightLightedSuggestion() {
        subject.searchBarText = "cat"

        #expect((subject.highlightSuggestion(suggestion: "category") as Any) is NSAttributedString)
    }
}
