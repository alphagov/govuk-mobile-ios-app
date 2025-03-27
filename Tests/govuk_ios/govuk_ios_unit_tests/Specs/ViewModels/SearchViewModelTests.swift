import Foundation
import Testing

@testable import GOVKitTestUtilities
@testable import govuk_ios

@Suite
struct SearchViewModelTests{

    @Test
    func selected_tracksItem() {
        let mockAnalyticsService = MockAnalyticsService()
        let subject = SearchViewModel(
            analyticsService: mockAnalyticsService,
            searchService: MockSearchService(), 
            activityService: MockActivityService(),
            urlOpener: MockURLOpener()
        )
        let expectedTitle = UUID().uuidString
        let item = SearchItem(
            title: expectedTitle,
            description: UUID().uuidString,
            link: URL(string: "https://www.gov.uk/random")!
        )

        subject.selected(
            item: item
        )

        let events = mockAnalyticsService._trackedEvents
        #expect(events.count == 1)
        #expect(events.last?.name == "Navigation")
        #expect(events.last?.params?["text"] as! String == expectedTitle)
        #expect(events.last?.params?["url"] as! String == "https://www.gov.uk/random")
        #expect(events.last?.params?["external"] as! Bool)
    }

    @Test
    func selected_savesRecentActivity() {
        let mockActivityService = MockActivityService()
        let subject = SearchViewModel(
            analyticsService: MockAnalyticsService(),
            searchService: MockSearchService(),
            activityService: mockActivityService,
            urlOpener: MockURLOpener()
        )
        let expectedTitle = UUID().uuidString
        let item = SearchItem(
            title: expectedTitle,
            description: UUID().uuidString,
            link: URL(string: "https://www.google.com/random")!
        )
        
        let expectedItem = ActivityItemCreateParams(searchItem: item)
        
        subject.selected(
            item: item
        )

        #expect(mockActivityService._receivedSaveActivity == expectedItem)
    }

    @Test
    func search_success_setsResults() {
        let mockAnalyticsService = MockAnalyticsService()
        let mockService = MockSearchService()
        let subject = SearchViewModel(
            analyticsService: mockAnalyticsService,
            searchService: mockService,
            activityService: MockActivityService(),
            urlOpener: MockURLOpener()
        )
        let searchText = "E3 6SY bin collection"

        subject.search(
            text: searchText,
            type: .typed,
            completion: { }
        )

        let stubbedResponse = SearchResult(
            results: [
                .arrange,
                .arrange,
            ]
        )
        mockService._searchReceivedCompletion?(.success(stubbedResponse))
        let events = mockAnalyticsService._trackedEvents
        let redactedSearchText = "[postcode] bin collection"

        #expect(subject.results?.count == stubbedResponse.results.count)
        #expect(events.count == 1)
        #expect(events.first?.name == "Search")
        #expect(events.first?.params?["text"] as! String == redactedSearchText)
    }

    @Test
    func search_noResults_setsError() {
        let mockAnalyticsService = MockAnalyticsService()
        let mockService = MockSearchService()
        let subject = SearchViewModel(
            analyticsService: mockAnalyticsService,
            searchService: mockService,
            activityService: MockActivityService(),
            urlOpener: MockURLOpener()
        )
        let searchText = UUID().uuidString

        subject.search(
            text: searchText,
            type: .typed,
            completion: { }
        )

        mockService._searchReceivedCompletion?(.failure(.noResults))
        #expect(subject.results == nil)
        #expect(subject.error == .noResults)
    }

    @Test
    func search_apiUnavailable_updatesErrorState() {
        let mockAnalyticsService = MockAnalyticsService()
        let mockService = MockSearchService()
        let subject = SearchViewModel(
            analyticsService: mockAnalyticsService,
            searchService: mockService,
            activityService: MockActivityService(),
            urlOpener: MockURLOpener()
        )
        let searchText = "ASDLALSD"

        subject.search(
            text: searchText,
            type: .autocomplete,
            completion: { }
        )

        mockService._searchReceivedCompletion?(.failure(.apiUnavailable))
        #expect(subject.results == nil)
        #expect(subject.error == .apiUnavailable)
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

// The synthesized conformance to Equatable fails for tests because Swift Testing seems to think
// the 'id' parameter is a generic parameter for identifying views, not a String.  So need to
// add an explicit implementation.  Declaring it here as we only require it for testing at the moment.
extension ActivityItemCreateParams: @retroactive Equatable {
    public static func == (lhs: ActivityItemCreateParams, rhs: ActivityItemCreateParams) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.url == rhs.url
    }
}

enum MockNetworkError: Error {
    case tooManyRequests
}
