import Foundation
import Testing

@testable import govuk_ios

@Suite
struct SearchViewModelTests{

    @Test
    func selected_tracksEvent() {
        let mockAnalyticsService = MockAnalyticsService()
        let subject = SearchViewModel(
            analyticsService: mockAnalyticsService,
            searchService: MockSearchService(),
            activityService: MockActivityService(),
            urlOpener: MockURLOpener(),
            openAction: { _ in }
        )
        let expectedTitle = UUID().uuidString
        let item = SearchItem(
            title: expectedTitle,
            description: UUID().uuidString,
            contentId: nil,
            link: URL(string: "https://www.gov.uk/random")!
        )

        subject.selected(item: item)

        let events = mockAnalyticsService._trackedEvents
        #expect(events.count == 1)
        #expect(events.last?.name == "Navigation")
        #expect(events.last?.params?["text"] as! String == expectedTitle)
        #expect(events.last?.params?["url"] as! String == "https://www.gov.uk/random")
        #expect(events.last?.params?["external"] as! Bool)
    }

    @Test
    func selected_tracksEcommerceEvent() {
        let mockAnalyticsService = MockAnalyticsService()
        let mockSearchService = MockSearchService()
        let expectedTitle = UUID().uuidString
        let expectedDescription = UUID().uuidString
        let expectedContentId = UUID().uuidString
        let expectedLink = URL(string: "https://www.govuk.com/test")!
        let searchItem = SearchItem(
            title: expectedTitle,
            description: expectedDescription,
            contentId: expectedContentId,
            link: expectedLink
        )
        mockSearchService._stubbedSearchResult = .success(
            SearchResult(results: [searchItem])
        )
        let subject = SearchViewModel(
            analyticsService: mockAnalyticsService,
            searchService: mockSearchService,
            activityService: MockActivityService(),
            urlOpener: MockURLOpener(),
            openAction: { _ in }
        )
        let searchTerm = "search term"

        subject.search(text: searchTerm, type: .typed, completion: { })
        subject.selected(item: searchItem)

        let events = mockAnalyticsService._trackedEvents
        let selectItemEvent = events.first { $0.name == "select_item" }
        #expect(selectItemEvent?.name == "select_item")
        #expect(selectItemEvent?.params?["item_list_name"] as! String == "Search / \(expectedTitle)")
        #expect(selectItemEvent?.params?["item_list_id"] as! String == expectedTitle)
        #expect(selectItemEvent?.params?["results"] as! Int == 1)
        let selectedItem = (events.last?.params?["items"] as? [[String: String]])?.first
        #expect(selectedItem?["item_name"] == expectedTitle)
        #expect(selectedItem?["index"] == "1")
        #expect(selectedItem?["term"] == searchTerm)
        #expect(selectedItem?["item_location"] == expectedLink.absoluteString)
        #expect(selectedItem?["item_id"] == expectedContentId)
    }

    @Test
    func selected_savesRecentActivity() {
        let mockActivityService = MockActivityService()
        let subject = SearchViewModel(
            analyticsService: MockAnalyticsService(),
            searchService: MockSearchService(),
            activityService: mockActivityService,
            urlOpener: MockURLOpener(),
            openAction: { _ in }
        )
        let expectedTitle = UUID().uuidString
        let item = SearchItem(
            title: expectedTitle,
            description: UUID().uuidString,
            contentId: nil,
            link: URL(string: "https://www.google.com/random")!
        )
        let expectedItem = ActivityItemCreateParams(searchItem: item)
        
        subject.selected(item: item)

        #expect(mockActivityService._receivedSaveActivity == expectedItem)
    }

    @Test
    func search_setsResults() {
        let mockAnalyticsService = MockAnalyticsService()
        let mockService = MockSearchService()
        let subject = SearchViewModel(
            analyticsService: mockAnalyticsService,
            searchService: mockService,
            activityService: MockActivityService(),
            urlOpener: MockURLOpener(),
            openAction: { _ in }
        )
        let searchTerm = "E3 6SY bin collection"

        subject.search(
            text: searchTerm,
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
        #expect(subject.results?.count == stubbedResponse.results.count)
    }

    @Test
    func search_tracksEvent() {
        let mockAnalyticsService = MockAnalyticsService()
        let mockService = MockSearchService()
        let subject = SearchViewModel(
            analyticsService: mockAnalyticsService,
            searchService: mockService,
            activityService: MockActivityService(),
            urlOpener: MockURLOpener(),
            openAction: { _ in }
        )
        let searchTerm = "E3 6SY bin collection"

        subject.search(
            text: searchTerm,
            type: .typed,
            completion: { }
        )

        let events = mockAnalyticsService._trackedEvents
        let redactedSearchTerm = "[postcode] bin collection"
        #expect(events.count == 1)
        #expect(events.first?.name == "Search")
        #expect(events.first?.params?["text"] as! String == redactedSearchTerm)
    }

    @Test
    func search_tracksEcommerceEvent() {
        let mockAnalyticsService = MockAnalyticsService()
        let mockSearchService = MockSearchService()
        let expectedTitle = UUID().uuidString
        let expectedDescription = UUID().uuidString
        let expectedContentId = UUID().uuidString
        let expectedLink = URL(string: "https://www.govuk.com/test")!
        let searchItem = SearchItem(
            title: expectedTitle,
            description: expectedDescription,
            contentId: expectedContentId,
            link: expectedLink
        )
        mockSearchService._stubbedSearchResult = .success(
            SearchResult(results: [searchItem])
        )
        let subject = SearchViewModel(
            analyticsService: mockAnalyticsService,
            searchService: mockSearchService,
            activityService: MockActivityService(),
            urlOpener: MockURLOpener(),
            openAction: { _ in }
        )
        let searchTerm = "search term"

        subject.search(text: searchTerm, type: .typed, completion: { })

        let events = mockAnalyticsService._trackedEvents
        let selectItemEvent = events.first { $0.name == "view_item_list" }
        #expect(selectItemEvent?.name == "view_item_list")
        #expect(selectItemEvent?.params?["item_list_name"] as! String == "Search")
        #expect(selectItemEvent?.params?["item_list_id"] as! String == "Search")
        #expect(selectItemEvent?.params?["results"] as! Int == 1)
        let selectedItem = (events.last?.params?["items"] as? [[String: String]])?.first
        #expect(selectedItem?["item_name"] == expectedTitle)
        #expect(selectedItem?["index"] == "1")
        #expect(selectedItem?["term"] == searchTerm)
        #expect(selectedItem?["item_location"] == expectedLink.absoluteString)
        #expect(selectedItem?["item_id"] == expectedContentId)
    }

    @Test
    func search_noResults_setsError() {
        let mockAnalyticsService = MockAnalyticsService()
        let mockService = MockSearchService()
        let subject = SearchViewModel(
            analyticsService: mockAnalyticsService,
            searchService: mockService,
            activityService: MockActivityService(),
            urlOpener: MockURLOpener(),
            openAction: { _ in }
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
            urlOpener: MockURLOpener(),
            openAction: { _ in }
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
