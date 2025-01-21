import Foundation
import UIKit
import GOVKit

class SearchSuggestionsViewModel {
    private let searchService: SearchServiceInterface
    private let suggestionHighlighterProcessor = SuggestionHighlighterProcessor()
    let analyticsService: AnalyticsServiceInterface

    var suggestions: [SearchSuggestion] = []
    var searchBarText: String = ""

    init(searchService: SearchServiceInterface,
         analyticsService: AnalyticsServiceInterface) {
        self.searchService = searchService
        self.analyticsService = analyticsService
    }

    func suggestions(completion: @escaping () -> Void) {
        guard !searchBarText.isEmpty
        else {
            suggestions = []
            return
        }

        searchService.suggestions(
            searchBarText,
            completion: { [weak self] fetchedSuggestions in
                self?.suggestions = fetchedSuggestions.map {
                    SearchSuggestion(text: $0)
                }
                completion()
            }
        )
    }

    func clearSuggestions() {
        suggestions = []
    }

    func highlightSuggestion(suggestion: String) -> NSAttributedString {
        suggestionHighlighterProcessor.process(text: searchBarText, suggestion: suggestion)
    }
}
