import Foundation
import XCTest

@testable import govuk_ios

final class SearchViewModelTestsXC: XCTestCase {

    var subject: SearchViewModel!
    var mockAnalyticsService: MockAnalyticsService!
    var mockSearchService: MockSearchService!
    var mockActivityService: MockActivityService!
    var mockURLOpener: MockURLOpener!
    
    override func setUp() {
        super.setUp()
        mockAnalyticsService = MockAnalyticsService()
        mockSearchService = MockSearchService()
        mockActivityService = MockActivityService()
        mockURLOpener = MockURLOpener()
        subject = SearchViewModel(
            analyticsService: mockAnalyticsService,
            searchService: mockSearchService,
            activityService: mockActivityService,
            urlOpener: mockURLOpener
        )
    }

    override func tearDown() {
        subject = nil
        mockAnalyticsService = nil
        mockSearchService = nil
        mockActivityService = nil
        mockURLOpener = nil
        super.tearDown()
    }
    
    func test_selected_tracksItem() {
        let expectedTitle = UUID().uuidString
        let item = SearchItem(
            title: expectedTitle,
            description: UUID().uuidString,
            link: "/random"
        )

        subject.selected(
            item: item
        )

        let events = mockAnalyticsService._trackedEvents
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.last?.name, "Navigation")
        XCTAssertEqual(events.last?.params?["text"] as! String,expectedTitle)
        XCTAssertEqual(events.last?.params?["url"] as! String, "https://www.gov.uk/random")
        XCTAssertTrue(events.last?.params?["external"] as! Bool)
    }

    func test_selected_savesRecentActivity() {
        let expectedTitle = UUID().uuidString
        let item = SearchItem(
            title: expectedTitle,
            description: UUID().uuidString,
            link: "/random"
        )

        subject.selected(
            item: item
        )

        XCTAssertEqual(mockActivityService._receivedSaveSearchItem, item)
    }

    func test_search_success_setsResults() {
        let searchText = UUID().uuidString

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
        mockSearchService._searchReceivedCompletion?(.success(stubbedResponse))
        let events = mockAnalyticsService._trackedEvents

        XCTAssertEqual(subject.results?.count, stubbedResponse.results.count)
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.first?.name, "Search")
        XCTAssertEqual(events.first?.params?["text"] as! String, searchText)
    }

    func test_search_noResults_setsError() {
        let searchText = UUID().uuidString

        subject.search(
            text: searchText,
            completion: { }
        )

        mockSearchService._searchReceivedCompletion?(.failure(.noResults))
        XCTAssertEqual(subject.results, nil)
        XCTAssertEqual(subject.error, .noResults)
    }

    func test_search_apiUnavailable_updatesErrorState() {
        let searchText = "ASDLALSD"

        subject.search(
            text: searchText,
            completion: { }
        )

        mockSearchService._searchReceivedCompletion?(.failure(.apiUnavailable))
        XCTAssertEqual(subject.results, nil)
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
