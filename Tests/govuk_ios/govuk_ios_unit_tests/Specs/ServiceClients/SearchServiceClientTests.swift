import Foundation
import Testing

@testable import govuk_ios

@Suite
struct SearchServiceClientTests {

    @Test
    func search_sendsExpectedRequest() {
        let mockAPI = MockAPIServiceClient()
        let sut = SearchServiceClient(
            serviceClient: mockAPI,
            suggestionsServiceClient: mockAPI
        )
        let expectedTerm = UUID().uuidString
        sut.search(
            term: expectedTerm,
            completion: { _ in }
        )

        #expect(mockAPI._receivedSendRequest?.urlPath == "/v0_1/search.json")
        #expect(mockAPI._receivedSendRequest?.method == .get)
        #expect(mockAPI._receivedSendRequest?.queryParameters?["q"] as? String == expectedTerm)
        #expect(mockAPI._receivedSendRequest?.queryParameters?["count"] as? String == "10")
    }

    @Test
    func search_success_returnsExpectedResult() async {
        let mockAPI = MockAPIServiceClient()
        let sut = SearchServiceClient(
            serviceClient: mockAPI,
            suggestionsServiceClient: mockAPI
        )
        let expectedResult = SearchResult(
            results: [
                .arrange(title: "test", description: "test"),
                .arrange(title: "test2", description: "test"),
                .arrange(title: "test3", description: "test"),
            ]
        )

        let stubbedData = try! JSONEncoder().encode(expectedResult)
        mockAPI._stubbedSendResponse = .success(stubbedData)
        let result = await withCheckedContinuation { continuation in
            sut.search(
                term: "test",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }
        let searchResult = try? result.get()
        #expect(searchResult?.results.count == 3)
        #expect(searchResult?.results.first?.title == "test")
    }

    @Test
    func search_failure_apiUnavailable_returnsExpectedResult() async {
        let mockAPI = MockAPIServiceClient()
        let sut = SearchServiceClient(
            serviceClient: mockAPI,
            suggestionsServiceClient: mockAPI
        )
        mockAPI._stubbedSendResponse = .failure(TestError.fakeNetwork)
        let result = await withCheckedContinuation { continuation in
            sut.search(
                term: "test",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }
        let searchResult = try? result.get()
        #expect(searchResult == nil)
        #expect(result.getError() == .apiUnavailable)
    }

    @Test
    func search_failure_networkUnavailable_returnsExpectedResult() async {
        let mockAPI = MockAPIServiceClient()
        let sut = SearchServiceClient(
            serviceClient: mockAPI,
            suggestionsServiceClient: mockAPI
        )
        mockAPI._stubbedSendResponse = .failure(
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
        #expect(searchResult == nil)
        #expect(result.getError() == .networkUnavailable)
    }

    @Test
    func search_success_wrongDataFormat_returnsExpectedResult() async {
        let mockAPI = MockAPIServiceClient()
        let sut = SearchServiceClient(
            serviceClient: mockAPI,
            suggestionsServiceClient: mockAPI
        )
        let invalidObject = try! JSONEncoder().encode("Test")
        mockAPI._stubbedSendResponse = .success(invalidObject)
        let result = await withCheckedContinuation { continuation in
            sut.search(
                term: "test",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }
        let searchResult = try? result.get()
        #expect(searchResult == nil)
        #expect(result.getError() == .parsingError)
    }

    @Test
    func suggestions_sendsExpectedRequest() {
        let mockAPI = MockAPIServiceClient()
        let sut = SearchServiceClient(
            serviceClient: mockAPI,
            suggestionsServiceClient: mockAPI
        )
        let expectedTerm = UUID().uuidString
        sut.suggestions(
            term: expectedTerm,
            completion: { _ in }
        )

        #expect(mockAPI._receivedSendRequest?.urlPath == "/api/search/autocomplete.json")
        #expect(mockAPI._receivedSendRequest?.method == .get)
        #expect(mockAPI._receivedSendRequest?.queryParameters?["q"] as? String == expectedTerm)
    }

    @Test
    func suggestions_success_returnsExpectedResult() async {
        let mockAPI = MockAPIServiceClient()
        let sut = SearchServiceClient(
            serviceClient: mockAPI,
            suggestionsServiceClient: mockAPI
        )
        let expectedResult = SearchSuggestions(
            suggestions: [
                "A good suggestion",
                "Another good one"
            ]
        )

        let stubbedData = try! JSONEncoder().encode(expectedResult)
        mockAPI._stubbedSendResponse = .success(stubbedData)
        let result = await withCheckedContinuation { continuation in
            sut.suggestions(
                term: "good",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }
        let suggestionsResult = try? result.get()
        #expect(suggestionsResult?.suggestions.count == 2)
    }

    @Test
    func suggestions_failure_apiUnavailable_returnsExpectedResult() async {
        let mockAPI = MockAPIServiceClient()
        let sut = SearchServiceClient(
            serviceClient: mockAPI,
            suggestionsServiceClient: mockAPI
        )
        mockAPI._stubbedSendResponse = .failure(TestError.fakeNetwork)
        let result = await withCheckedContinuation { continuation in
            sut.suggestions(
                term: "good",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }
        let searchResult = try? result.get()
        #expect(searchResult == nil)
        #expect(result.getError() == .apiUnavailable)
    }

    @Test
    func suggestions_failure_networkUnavailable_returnsExpectedResult() async {
        let mockAPI = MockAPIServiceClient()
        let sut = SearchServiceClient(
            serviceClient: mockAPI,
            suggestionsServiceClient: mockAPI
        )
        mockAPI._stubbedSendResponse = .failure(
            NSError(domain: "TestError", code: NSURLErrorNotConnectedToInternet)
        )
        let result = await withCheckedContinuation { continuation in
            sut.suggestions(
                term: "test",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }
        let searchResult = try? result.get()
        #expect(searchResult == nil)
        #expect(result.getError() == .networkUnavailable)
    }

    @Test
    func suggestions_success_wrongDataFormat_returnsExpectedResult() async {
        let mockAPI = MockAPIServiceClient()
        let sut = SearchServiceClient(
            serviceClient: mockAPI,
            suggestionsServiceClient: mockAPI
        )
        let invalidObject = try! JSONEncoder().encode("Test")
        mockAPI._stubbedSendResponse = .success(invalidObject)
        let result = await withCheckedContinuation { continuation in
            sut.suggestions(
                term: "test",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }
        let searchResult = try? result.get()
        #expect(searchResult == nil)
        #expect(result.getError() == .parsingError)
    }

}
