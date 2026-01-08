import Foundation
import Testing
import GOVKit

@testable import govuk_ios

@Suite
struct AppEvent_SearchTests {

    @Test
    func searchItemNavigation_returnsExpectedResult() {
        let expectedTitle = UUID().uuidString
        let expectedURL = URL(string: "https://www.gov.uk/random")!
        let item = SearchItem(
            title: expectedTitle,
            description: "description",
            contentId: nil,
            link: expectedURL
        )
        let result = AppEvent.searchResultNavigation(
            item: item
        )

        #expect(result.name == "Navigation")
        #expect(result.params?.count == 5)
        #expect(result.params?["text"] as? String == expectedTitle)
        #expect(result.params?["url"] as? String == "https://www.gov.uk/random")
        #expect(result.params?["type"] as? String == "SearchResult")
        #expect(result.params?["external"] as? Bool == true)
        #expect(result.params?["language"] as? String == "en")
    }

    @Test
    func searchTerm_returnsExpectedResult() {
        let expectedTerm = UUID().uuidString
        let result = AppEvent.searchTerm(
            term: expectedTerm,
            type: .typed
        )

        #expect(result.name == "Search")
        #expect(result.params?.count == 2)
        #expect(result.params?["text"] as? String == expectedTerm)
        #expect(result.params?["type"] as? String == "typed")
    }

}
