import Foundation
import Testing
import GOVKit

@testable import govuk_ios

@Suite
struct GOVRequest_SearchTests {
    @Test
    func search_returnsExpectedValues() {
        let expectedTerm = UUID().uuidString
        let request = GOVRequest.search(term: expectedTerm)

        #expect(request.urlPath == "/v0_1/search.json")
        #expect(request.method == .get)
        #expect(request.signingKey == nil)
        #expect(request.bodyParameters == nil)
        #expect(request.queryParameters?.count == 2)
        #expect(request.queryParameters?["q"] == expectedTerm)
        #expect(request.queryParameters?["count"] == "10")
        #expect(request.additionalHeaders == nil)
    }

    @Test
    func searchSuggestions_returnsExpectedValues() {
        let expectedTerm = UUID().uuidString
        let request = GOVRequest.searchSuggestions(term: expectedTerm)

        #expect(request.urlPath == "/api/search/autocomplete.json")
        #expect(request.method == .get)
        #expect(request.signingKey == nil)
        #expect(request.bodyParameters == nil)
        #expect(request.queryParameters?.count == 1)
        #expect(request.queryParameters?["q"] == expectedTerm)
        #expect(request.additionalHeaders == nil)
    }
}
