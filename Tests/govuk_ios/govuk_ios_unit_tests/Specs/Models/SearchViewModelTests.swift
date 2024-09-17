import Foundation
import XCTest

@testable import govuk_ios

class SearchViewModelTests: XCTestCase {
    func test_trackSearchTerm_tracksTerm() {
        let mockAnalyticsService = MockAnalyticsService()
        let subject = SearchViewModel(
            analyticsService: mockAnalyticsService
        )
        let searchText = "What is the meaning of life?"

        subject.trackSearchTerm(searchTerm: searchText)

        let events = mockAnalyticsService._trackedEvents
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.first?.name, "Search")
        XCTAssertEqual(events.first?.params?["text"] as! String, searchText)
    }

    func test_fetchSearchResults_returnsSearchItems() {
        let mockAnalyticsService = MockAnalyticsService()
        let mockAPIServiceClient = MockAPIServiceClient()
        mockAPIServiceClient._setNetworkRequestResponse = .success(JSONResponseData)
        let subject = SearchViewModel(
            analyticsService: mockAnalyticsService
        )
        let searchText = "Passport for dogs"

        subject.govukAPIClient = mockAPIServiceClient

        subject.fetchSearchResults(
            searchText: searchText, tableView: UITableView()
        )

        XCTAssertEqual(subject.searchResults?.count, 2)
    }

    func test_fetchSearchResults_blankSearch_returnsEarly() {
        let mockAnalyticsService = MockAnalyticsService()
        let mockAPIServiceClient = MockAPIServiceClient()
        let subject = SearchViewModel(
            analyticsService: mockAnalyticsService
        )
        let searchText = ""
        
        let sendExpectation = expectation()
        sendExpectation.isInverted = true
        mockAPIServiceClient.sendExpectation = sendExpectation
        subject.govukAPIClient = mockAPIServiceClient

        subject.fetchSearchResults(
            searchText: searchText, tableView: UITableView()
        )
        
        waitForExpectations(timeout: 0, handler: nil)
    }

    func test_fetchSearchResults_noResults_returnsNothing() {
        let mockAnalyticsService = MockAnalyticsService()
        let mockAPIServiceClient = MockAPIServiceClient()
        mockAPIServiceClient._setNetworkRequestResponse = .success(emptyJSONResponseData)
        let subject = SearchViewModel(
            analyticsService: mockAnalyticsService
        )
        let searchText = "ASDLALSD"

        subject.govukAPIClient = mockAPIServiceClient

        subject.fetchSearchResults(
            searchText: searchText, tableView: UITableView()
        )

        XCTAssertEqual(subject.searchResults?.count, 0)
    }

    private let JSONResponseData = """
    {"results": [
        {
            "title": "Something about passports",
            "description": "Something passporty must be taking place here",
            "link": "/apply-renew-passport"
        },
        {
            "title": "Driving abroad",
            "description": "Drrrrrrrrrivving abroad on a magical bus with thunder in the sky",
            "link": "/driving-abroad"
        }
    ]}
    """.data(using: .utf8)!

    private let emptyJSONResponseData = """
    {"results": []}
    """.data(using: .utf8)!
}
