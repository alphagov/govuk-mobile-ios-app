import Foundation
import UIKit

class SearchSuggestionsViewModel {
    private let searchService: SearchServiceInterface

    var suggestions: [SearchSuggestion] = []
    var searchBarText: String = ""

    init(searchService: SearchServiceInterface) {
        self.searchService = searchService
    }

    func suggestions(completion: @escaping () -> Void) {
        guard !searchBarText.isEmpty, searchBarText.count >= 3
        else { return suggestions = [] }

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
}
