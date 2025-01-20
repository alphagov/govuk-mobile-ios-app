import Foundation
import Testing

@testable import govuk_ios

@Suite
struct SearchServiceTests {

    @Test
    func search_callsServiceClient() {
        let mockServiceClient = MockSearchServiceClient()
        let mockRespository = MockSearchHistoryRepository()
        let sut = SearchService(
            serviceClient: mockServiceClient,
            repository: mockRespository
        )
        let expectedTerm = UUID().uuidString
        sut.search(
            expectedTerm,
            completion: { _ in }
        )
        #expect(mockServiceClient._receivedSearchTerm == expectedTerm)
    }

    @Test
    func search_success_returnsExpectedResult() async {
        let mockServiceClient = MockSearchServiceClient()
        let mockRespository = MockSearchHistoryRepository()
        let sut = SearchService(
            serviceClient: mockServiceClient,
            repository: mockRespository
        )
        let expectedSearchResult = SearchResult(
            results: [
                .arrange(title: "test", description: "test"),
                .arrange(title: "test2", description: "test"),
                .arrange(title: "test3", description: "test"),
            ]
        )
        mockServiceClient._stubbedSearchResult = .success(expectedSearchResult)
        let result = await withCheckedContinuation { continuation in
            sut.search(
                "test",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }
        let results = try? result.get().results
        #expect(results?.count == 3)
        #expect(results?.first?.title == "test")
    }

    @Test
    func search_failure_returnsExpectedResult() async {
        let mockServiceClient = MockSearchServiceClient()
        let mockRespository = MockSearchHistoryRepository()
        let sut = SearchService(
            serviceClient: mockServiceClient,
            repository: mockRespository
        )
        mockServiceClient._stubbedSearchResult = .failure(.apiUnavailable)
        let result = await withCheckedContinuation { continuation in
            sut.search(
                "test",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }
        #expect((try? result.get()) == nil)
        #expect(result.getError() == .apiUnavailable)
    }

    @Test
    func search_success_noResults_returnsExpectedResult() async {
        let mockServiceClient = MockSearchServiceClient()
        let mockRepository = MockSearchHistoryRepository()
        let sut = SearchService(
            serviceClient: mockServiceClient,
            repository: mockRepository
        )
        let stubbedResult = SearchResult(results: [])
        mockServiceClient._stubbedSearchResult = .success(stubbedResult)
        let result = await withCheckedContinuation { continuation in
            sut.search(
                "test",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }
        #expect((try? result.get()) == nil)
        #expect(result.getError() == .noResults)
    }

    @Test
    func suggestions_callsServiceClient() {
        let mockServiceClient = MockSearchServiceClient()
        let mockRepository = MockSearchHistoryRepository()
        let sut = SearchService(
            serviceClient: mockServiceClient,
            repository: mockRepository
        )
        let expectedTerm = UUID().uuidString
        sut.suggestions(
            expectedTerm,
            completion: { _ in }
        )
        #expect(mockServiceClient._receivedTerm == expectedTerm)
    }

    @Test
    func suggestions_success_returnsExpectedResult() async {
        let mockServiceClient = MockSearchServiceClient()
        let mockRepository = MockSearchHistoryRepository()
        let sut = SearchService(
            serviceClient: mockServiceClient,
            repository: mockRepository
        )
        let stubbedSuggestion = SearchSuggestions(suggestions: ["A good suggestion"])
        mockServiceClient._stubbedSuggestionsResult = .success(stubbedSuggestion)
        let suggestions = await withCheckedContinuation { continuation in
            sut.suggestions(
                "good",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }
        #expect(suggestions == ["A good suggestion"])
    }

    @Test
    func suggestions_failure_returnsExpectedResult() async {
        let mockServiceClient = MockSearchServiceClient()
        let mockRepository = MockSearchHistoryRepository()
        let sut = SearchService(
            serviceClient: mockServiceClient,
            repository: mockRepository
        )
        mockServiceClient._stubbedSuggestionsResult = .failure(.apiUnavailable)
        let suggestions = await withCheckedContinuation { continuation in
            sut.suggestions(
                "good",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }
        #expect(suggestions == [])
    }

    func save_search_savesSearchToRepository() async {
        let mockServiceClient = MockSearchServiceClient()
        let mockRepository = MockSearchHistoryRepository()
        let sut = SearchService(
            serviceClient: mockServiceClient,
            repository: mockRepository
        )
        sut.save(searchText: "test", date: .init())
        #expect(mockRepository._didSaveSearchHistory)
        #expect(mockRepository._savedSearchText == "test")
    }

    @Test
    func clear_searchHistory_clearsRepository() async {
        let mockServiceClient = MockSearchServiceClient()
        let mockRepository = MockSearchHistoryRepository()
        let sut = SearchService(
            serviceClient: mockServiceClient,
            repository: mockRepository
        )
        sut.clearSearchHistory()
        #expect(mockRepository._didClearSearchHistory)
    }

    @Test
    func delete_searchHistory_deletesFromRepository() async {
        let mockServiceClient = MockSearchServiceClient()
        let mockRepository = MockSearchHistoryRepository()
        let sut = SearchService(
            serviceClient: mockServiceClient,
            repository: mockRepository
        )
        sut.delete(SearchHistoryItem())
        #expect(mockRepository._didDeleteSearchHistoryItem)
    }
}
