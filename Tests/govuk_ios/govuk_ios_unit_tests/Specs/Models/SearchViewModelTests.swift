import Foundation
import XCTest

@testable import govuk_ios

class SearchViewModelTests: XCTestCase {
    func test_trackSearchTerm_tracksTerm() {
        let mockAnalyticsService = MockAnalyticsService()
        let subject = SearchViewModel(
            analyticsService: mockAnalyticsService
        )
        let searchTerm = "What is the meaning of life?"

        subject.trackSearchTerm(searchTerm: searchTerm)

        let events = mockAnalyticsService._trackedEvents
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.first?.name, "Search")
        XCTAssertEqual(events.first?.params?["text"] as! String, searchTerm)
    }
}
