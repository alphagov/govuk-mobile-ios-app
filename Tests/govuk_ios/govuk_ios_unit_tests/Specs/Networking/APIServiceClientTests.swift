import Foundation
import Testing

@testable import govuk_ios

@Suite(.serialized)
struct APIServiceClientTests {

    @Test()
    func send_post_withParameters_passesExpectedValues() async throws {
        let subject = APIServiceClient(
            baseUrl: URL(string: "https://www.google.com")!,
            session: URLSession.mock,
            requestBuilder: RequestBuilder()
        )
        let govRequest = GOVRequest(
            urlPath: "/test/test",
            method: .post,
            bodyParameters: ["test_key": "test_value"],
            queryParameters: nil,
            additionalHeaders: nil
        )
        MockURLProtocol.requestHandlers["https://www.google.com/test/test"] = { request in
            #expect(request.url?.absoluteString == "https://www.google.com/test/test")
            #expect(request.httpMethod == "POST")
            let data = request.bodySteamData
            #expect(data != nil)
            let json = try? JSONDecoder().decode([String: String].self, from: data!)
            #expect(json?["test_key"] == "test_value")
            return (.arrangeSuccess, nil, nil)
        }
        return await withCheckedContinuation { continuation in
            subject.send(
                request: govRequest,
                completion: { result in
                    continuation.resume(returning: Void())
                }
            )
        }
    }

    @Test()
    func send_get_passesExpectedValues() async {
        let subject = APIServiceClient(
            baseUrl: URL(string: "https://www.google.com")!,
            session: URLSession.mock,
            requestBuilder: RequestBuilder()
        )
        let request = GOVRequest(
            urlPath: "/test/111",
            method: .get,
            bodyParameters: nil,
            queryParameters: ["query": "value"],
            additionalHeaders: nil
        )
        MockURLProtocol.requestHandlers["https://www.google.com/test/111"] = { request in
            #expect(request.url?.absoluteString == "https://www.google.com/test/111?query=value")
            #expect(request.httpMethod == "GET")
            #expect(request.httpBody == nil)
            return (.arrangeSuccess, nil, nil)
        }
        return await withCheckedContinuation { continuation in
            subject.send(
                request: request,
                completion: { result in
                    continuation.resume(returning: Void())
                }
            )
        }
    }

    @Test()
    func send_successResponse_returnsExpectedResult() async {
        let subject = APIServiceClient(
            baseUrl: URL(string: "https://www.google.com")!,
            session: URLSession.mock,
            requestBuilder: RequestBuilder()
        )
        let request = GOVRequest(
            urlPath: "/test/222",
            method: .get,
            bodyParameters: nil,
            queryParameters: nil,
            additionalHeaders: nil
        )
        let expectedResponse = HTTPURLResponse.arrange(statusCode: 200)
        let expectedData = Data()
        MockURLProtocol.requestHandlers["https://www.google.com/test/222"] = { request in
            return (expectedResponse, expectedData, nil)
        }
        return await withCheckedContinuation { continuation in
            subject.send(
                request: request,
                completion: { result in
                    let resultData = try? result.get()
                    #expect(resultData == expectedData)
                    continuation.resume(returning: Void())
                }
            )
        }
    }

    @Test()
    func send_successResponse_noData_returnsExpectedResult() async {
        let subject = APIServiceClient(
            baseUrl: URL(string: "https://www.google.com")!,
            session: URLSession.mock,
            requestBuilder: RequestBuilder()
        )
        let request = GOVRequest(
            urlPath: "/test/333",
            method: .get,
            bodyParameters: nil,
            queryParameters: nil,
            additionalHeaders: nil
        )
        let expectedResponse = HTTPURLResponse.arrange(statusCode: 200)
        MockURLProtocol.requestHandlers["https://www.google.com/test/333"] = { request in
            return (expectedResponse, nil, nil)
        }

        return await withCheckedContinuation { continuation in
            subject.send(
                request: request,
                completion: { result in
                    let resultData = try? result.get()
                    #expect(resultData != nil)
                    continuation.resume(returning: Void())
                }
            )
        }
    }

    @Test()
    func send_failureResponse_returnsExpectedResult() async {
        let subject = APIServiceClient(
            baseUrl: URL(string: "https://www.google.com")!,
            session: URLSession.mock,
            requestBuilder: RequestBuilder()
        )
        let request = GOVRequest(
            urlPath: "/test/444",
            method: .get,
            bodyParameters: nil,
            queryParameters: nil,
            additionalHeaders: nil
        )
        let expectedError = TestError.fakeNetwork
        MockURLProtocol.requestHandlers["https://www.google.com/test/444"] = { request in
            let expectedResponse = HTTPURLResponse.arrange(statusCode: 400)
            return (expectedResponse, nil, expectedError)
        }
        let result = await withCheckedContinuation { continuation in
            subject.send(
                request: request,
                completion: { continuation.resume(returning: $0) }
            )
        }
        if case .success = result {
            Issue.record("Expected failure, got: \(result)")
        }
    }
}

enum TestError: Error {
    case fakeNetwork
    case unexpectedMethodCalled
}
