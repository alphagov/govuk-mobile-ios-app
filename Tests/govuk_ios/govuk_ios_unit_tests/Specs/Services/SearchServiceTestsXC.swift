import Foundation
import XCTest

@testable import govuk_ios

final class SearchServiceTestsXC: XCTestCase {
    func test_search_callsServiceClient() {
        let mockServiceClient = MockSearchServiceClient()
        let sut = SearchService(
            serviceClient: mockServiceClient
        )
        let expectedTerm = UUID().uuidString
        sut.search(
            expectedTerm,
            completion: { _ in }
        )
        XCTAssertEqual(mockServiceClient._receivedSearchTerm, expectedTerm)
    }

    
    func test_search_success_returnsExpectedResult() async {
        let mockServiceClient = MockSearchServiceClient()
        let sut = SearchService(
            serviceClient: mockServiceClient
        )
        let expectedSearchResult = SearchResult(
            results: [
                .init(title: "test", description: "test", link: "test"),
                .init(title: "test2", description: "test", link: "test"),
                .init(title: "test3", description: "test", link: "test")
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
        XCTAssertEqual(results?.count , 3)
        XCTAssertEqual(results?.first?.title, "test")
    }

    
    func test_search_failure_returnsExpectedResult() async {
        let mockServiceClient = MockSearchServiceClient()
        let sut = SearchService(
            serviceClient: mockServiceClient
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
        XCTAssertNil(try? result.get())
        XCTAssertEqual(result.getError(), .apiUnavailable)
    }

    
    func test_search_success_noResults_returnsExpectedResult() async {
        let mockServiceClient = MockSearchServiceClient()
        let sut = SearchService(
            serviceClient: mockServiceClient
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
        XCTAssertNil(try? result.get())
        XCTAssertEqual(result.getError(), .noResults)
    }

}
