import XCTest

@testable import govuk_ios

final class SearchServiceClientTestsXC: XCTestCase {
    
    var sut: SearchServiceClient!
    var mockApiServiceClient: MockAPIServiceClient!
    
    override func setUp() {
        super.setUp()
        mockApiServiceClient = MockAPIServiceClient()
        sut = SearchServiceClient(
            serviceClient: mockApiServiceClient
        )
    }
    
    override func tearDown() {
        mockApiServiceClient = nil
        sut = nil
        super.tearDown()
    }
    
    func test_search_sendsExpectedRequest() {
        let expectedTerm = UUID().uuidString
        sut.search(
            term: expectedTerm,
            completion: { _ in }
        )

        XCTAssertEqual(mockApiServiceClient._receivedSendRequest?.urlPath, "/api/search.json")
        XCTAssertEqual(mockApiServiceClient._receivedSendRequest?.method, .get)
        XCTAssertEqual(mockApiServiceClient._receivedSendRequest?.queryParameters?["q"] as? String, expectedTerm)
        XCTAssertEqual(mockApiServiceClient._receivedSendRequest?.queryParameters?["count"] as? String, "10")
    }

    func test_search_success_returnsExpectedResult() async {
        let expectedResult = SearchResult(
            results: [
                .init(title: "test", description: "test", link: "123"),
                .init(title: "test2", description: "test", link: "123"),
                .init(title: "test3", description: "test", link: "123")
            ]
        )

        let stubbedData = try! JSONEncoder().encode(expectedResult)
        mockApiServiceClient._stubbedSendResponse = .success(stubbedData)
        let result = await withCheckedContinuation { continuation in
            sut.search(
                term: "test",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }
        let searchResult = try? result.get()
        XCTAssertEqual(searchResult?.results.count, 3)
        XCTAssertEqual(searchResult?.results.first?.title, "test")
    }

    func test_search_failure_apiUnavailable_returnsExpectedResult() async {
        mockApiServiceClient._stubbedSendResponse = .failure(TestError.fakeNetwork)
        let result = await withCheckedContinuation { continuation in
            sut.search(
                term: "test",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }
        let searchResult = try? result.get()
        XCTAssertNil(searchResult)
        XCTAssertEqual(result.getError(), .apiUnavailable)
    }

    func test_search_failure_networkUnavailable_returnsExpectedResult() async {
        mockApiServiceClient._stubbedSendResponse = .failure(
            NSError(domain: "TestError", code: NSURLErrorNotConnectedToInternet)
        )
        let result = await withCheckedContinuation { continuation in
            sut.search(
                term: "test",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }
        let searchResult = try? result.get()
        XCTAssertNil(searchResult)
        XCTAssertEqual(result.getError(), .networkUnavailable)
    }

    func test_search_success_wrongDataFormat_returnsExpectedResult() async {
        let invalidObject = try! JSONEncoder().encode("Test")
        mockApiServiceClient._stubbedSendResponse = .success(invalidObject)
        let result = await withCheckedContinuation { continuation in
            sut.search(
                term: "test",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }
        let searchResult = try? result.get()
        XCTAssertNil(searchResult)
        XCTAssertEqual(result.getError(), .parsingError)
    }

}
