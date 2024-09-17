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

    func test_trackSearchItem_tracksItem() {
        let mockAnalyticsService = MockAnalyticsService()
        let mockAPIServiceClient = MockAPIServiceClient()
        mockAPIServiceClient._setNetworkRequestResponse = .success(JSONResponseData)
        let subject = SearchViewModel(
            analyticsService: mockAnalyticsService
        )
        let searchText = "Passport for dogs"

        subject.govukAPIClient = mockAPIServiceClient
        subject.fetchSearchResults(
            searchText: searchText, completion: { }
        )

        let item = subject.searchResults?.last

        subject.trackSearchItemPress(item!)

        let events = mockAnalyticsService._trackedEvents
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.last?.name, "Search")
        XCTAssertEqual(events.last?.params?["title"] as! String, "Driving abroad")
        XCTAssertEqual(events.last?.params?["link"] as! String, "/driving-abroad")
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
            searchText: searchText, completion: { }
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
            searchText: searchText, completion: { }
        )
        
        waitForExpectations(timeout: 0, handler: nil)
    }

    func test_fetchSearchResults_noResults_updatesErrorState() {
        let mockAnalyticsService = MockAnalyticsService()
        let mockAPIServiceClient = MockAPIServiceClient()
        mockAPIServiceClient._setNetworkRequestResponse = .success(emptyJSONResponseData)
        let subject = SearchViewModel(
            analyticsService: mockAnalyticsService
        )
        let searchText = "ASDLALSD"

        subject.govukAPIClient = mockAPIServiceClient

        subject.fetchSearchResults(
            searchText: searchText, completion: { }
        )

        XCTAssertEqual(subject.searchResults?.count, 0)
        XCTAssertEqual(subject.searchErrorState, .noResults)
    }

    func test_fetchSearchResults_apiUnavailable_updatesErrorState() {
        let mockAnalyticsService = MockAnalyticsService()
        let mockAPIServiceClient = MockAPIServiceClient()
        mockAPIServiceClient._setNetworkRequestResponse = .failure(
            MockNetworkError.tooManyRequests
        )
        let subject = SearchViewModel(
            analyticsService: mockAnalyticsService
        )
        let searchText = "ASDLALSD"

        subject.govukAPIClient = mockAPIServiceClient

        subject.fetchSearchResults(
            searchText: searchText, completion: { }
        )

        XCTAssertEqual(subject.searchResults?.count, 0)
        XCTAssertEqual(subject.searchErrorState, .apiUnavailable)
    }

    func test_itemTitle_returnsTrimmedTitle() {
        let mockAnalyticsService = MockAnalyticsService()
        let mockAPIServiceClient = MockAPIServiceClient()
        mockAPIServiceClient._setNetworkRequestResponse = .success(JSONResponseData)
        let subject = SearchViewModel(
            analyticsService: mockAnalyticsService
        )
        let searchText = "Test"

        subject.govukAPIClient = mockAPIServiceClient

        subject.fetchSearchResults(
            searchText: searchText, completion: { }
        )

        XCTAssertEqual(subject.itemTitle(0), "Something about passports")
    }

    func test_itemDescription_returnsTrimmedDescription() {
        let mockAnalyticsService = MockAnalyticsService()
        let mockAPIServiceClient = MockAPIServiceClient()
        mockAPIServiceClient._setNetworkRequestResponse = .success(JSONResponseData)
        let subject = SearchViewModel(
            analyticsService: mockAnalyticsService
        )
        let searchText = "Test"

        subject.govukAPIClient = mockAPIServiceClient

        subject.fetchSearchResults(
            searchText: searchText, completion: { }
        )

        XCTAssertEqual(
            subject.itemDescription(0), 
            "Something passporty must be taking place here"
        )
    }

    private let JSONResponseData = """
    {"results": [
        {
            "title": " Something about passports ",
            "description": " Something passporty must be taking place here ",
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

enum MockNetworkError: Error {
    case tooManyRequests
}
