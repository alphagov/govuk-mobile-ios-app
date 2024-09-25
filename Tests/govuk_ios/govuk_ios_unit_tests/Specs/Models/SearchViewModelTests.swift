import Foundation
import XCTest

@testable import govuk_ios

class SearchViewModelTests: XCTestCase {
    func test_selected_tracksItem() {
        let mockAnalyticsService = MockAnalyticsService()

        let subject = SearchViewModel(
            analyticsService: mockAnalyticsService,
            searchService: MockSearchService(),
            urlOpener: MockURLOpener()
        )

        let expectedTitle = UUID().uuidString
        let expectedDescription = UUID().uuidString
        let item = SearchItem(
            title: expectedTitle,
            description: expectedDescription,
            link: "/random"
        )

        subject.selected(
            item: item
        )

        let events = mockAnalyticsService._trackedEvents
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.last?.name, "Navigation")
        XCTAssertEqual(events.last?.params?["text"] as! String, expectedTitle)
        XCTAssertEqual(events.last?.params?["url"] as! String, "https://www.gov.uk/random")
        XCTAssertEqual(events.last?.params?["external"] as! Bool, true)
    }

    func test_search_success_setsResults() {
        let mockAnalyticsService = MockAnalyticsService()
        let mockService = MockSearchService()
        let subject = SearchViewModel(
            analyticsService: mockAnalyticsService,
            searchService: mockService,
            urlOpener: MockURLOpener()
        )
        let searchText = "Passport for dogs"
        subject.search(
            text: searchText,
            completion: { }
        )
        let stubbedResponse = SearchResult(
            results: [
                .init(title: "", description: "", link: ""),
                .init(title: "", description: "", link: "")
            ]
        )
        mockService._searchReceivedCompletion?(.success(stubbedResponse))

        XCTAssertEqual(subject.results?.count, stubbedResponse.results.count)

        let events = mockAnalyticsService._trackedEvents
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.first?.name, "Search")
        XCTAssertEqual(events.first?.params?["text"] as! String, searchText)
    }

    func test_search_blankSearch_returnsEarly() {
        let mockAnalyticsService = MockAnalyticsService()
        let mockServiceClient = MockSearchService()
        let subject = SearchViewModel(
            analyticsService: mockAnalyticsService,
            searchService: mockServiceClient,
            urlOpener: MockURLOpener()
        )
        let searchText = ""

        let sendExpectation = expectation()
        sendExpectation.isInverted = true

        subject.search(
            text: searchText,
            completion: { }
        )

        waitForExpectations(timeout: 0, handler: nil)
    }

    func test_search_noResults_setsError() {
        let mockAnalyticsService = MockAnalyticsService()
        let mockService = MockSearchService()

        let subject = SearchViewModel(
            analyticsService: mockAnalyticsService,
            searchService: mockService,
            urlOpener: MockURLOpener()
        )
        let searchText = "ASDLALSD"

        subject.search(
            text: searchText,
            completion: { }
        )
        mockService._searchReceivedCompletion?(.failure(.noResults))

        XCTAssertNil(subject.results)
        XCTAssertEqual(subject.error, .noResults)
    }

    func test_search_apiUnavailable_updatesErrorState() {
        let mockAnalyticsService = MockAnalyticsService()
        let mockService = MockSearchService()

        let subject = SearchViewModel(
            analyticsService: mockAnalyticsService,
            searchService: mockService,
            urlOpener: MockURLOpener()
        )
        let searchText = "ASDLALSD"

        subject.search(
            text: searchText,
            completion: { }
        )
        mockService._searchReceivedCompletion?(.failure(.apiUnavailable))

        XCTAssertNil(subject.results)
        XCTAssertEqual(subject.error, .apiUnavailable)
    }

    private let successResponseData = """
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
