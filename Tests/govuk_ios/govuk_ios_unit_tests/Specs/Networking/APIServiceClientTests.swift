import Foundation
import Testing
import GOVKit
@testable import govuk_ios

@Suite(.serialized)
struct APIServiceClientTests {

    @Test()
    func send_post_withParameters_passesExpectedValues() async {
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
            let data = request.bodyStreamData
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
        let resultData = await withCheckedContinuation { continuation in
            subject.send(
                request: request,
                completion: { result in
                    let resultData = try? result.get()
                    continuation.resume(returning: resultData)
                }
            )
        }
        #expect(resultData == expectedData)
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

        let resultData = await withCheckedContinuation { continuation in
            subject.send(
                request: request,
                completion: { result in
                    let resultData = try? result.get()
                    continuation.resume(returning: resultData)
                }
            )
        }
        #expect(resultData != nil)
    }
    
    @Test()
    func send_signatureVerificationSuccess_returnsExpectedResult() async {
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
            additionalHeaders: nil,
            signingKey: Constants.SigningKey.govUK
        )
        let expectedResponse = HTTPURLResponse.arrange(
            statusCode: 200,
            headerFields: ["x-amz-meta-govuk-sig": "MEQCIDliiuOa6Htw22CnbtGnP0EZvybj1LQJvoSiHqIY3ZUnAiAr7YVRb3pYCGYG6caK4Lnc4IhIT5lbSm00fHpGBLwneQ=="])
        let expectedData = Self.dataMatchesSignature
        MockURLProtocol.requestHandlers["https://www.google.com/test/222"] = { request in
            return (expectedResponse, expectedData, nil)
        }
        let resultData = await withCheckedContinuation { continuation in
            subject.send(
                request: request,
                completion: { result in
                    let resultData = try? result.get()
                    continuation.resume(returning: resultData)
                }
            )
        }
        #expect(resultData == expectedData)
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
    
    @Test()
    func send_signatureVerificationFailure_returnsExpectedResult() async {
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
            additionalHeaders: nil,
            signingKey: Constants.SigningKey.govUK
        )
        let expectedResponse = HTTPURLResponse.arrange(
            statusCode: 200,
            headerFields: ["x-amz-meta-govuk-sig": "MEQCIDliiuOa6Htw22CnbtGnP0EZvybj1LQJvoSiHqIY3ZUnAiAr7YVRb3pYCGYG6caK4Lnc4IhIT5lbSm00fHpGBLwneQ=="])
        let expectedData = Self.dataDoesNotMatchSignature
        MockURLProtocol.requestHandlers["https://www.google.com/test/222"] = { request in
            return (expectedResponse, expectedData, nil)
        }
        let result = await withCheckedContinuation { continuation in
            subject.send(
                request: request,
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }
        let resultData = try? result.get()
        #expect(resultData == nil)
        let error = result.getError()
        #expect(error as? SigningError == SigningError.invalidSignature)
    }
    
    @Test()
    func send_invalidSignature_returnsExpectedResult() async {
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
            additionalHeaders: nil,
            signingKey: Constants.SigningKey.govUK
        )
        let expectedResponse = HTTPURLResponse.arrange(
            statusCode: 200,
            headerFields: ["x-amz-meta-govuk-sig": "InvalidSignatureData"])
        let expectedData = Self.dataMatchesSignature
        MockURLProtocol.requestHandlers["https://www.google.com/test/222"] = { request in
            return (expectedResponse, expectedData, nil)
        }
        let result = await withCheckedContinuation { continuation in
            subject.send(
                request: request,
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }
        let resultData = try? result.get()
        #expect(resultData == nil)
        let error = result.getError()
        #expect(error as? SigningError == SigningError.invalidSignature)
    }
}

enum TestError: Error {
    case fakeNetwork
    case unexpectedMethodCalled
}

private extension APIServiceClientTests {
    static let dataMatchesSignature: Data =
    """
    {
      "platform": "iOS",
      "config": {
        "available": true,
        "minimumVersion": "0.0.1",
        "recommendedVersion": "0.0.1",
        "releaseFlags": {
          "onboarding": true,
          "search": true,
          "topics": true,
          "recentActivity": true
        },
        "version": "0.0.5",
        "lastUpdated": "2024-10-30T09:55:51.351Z"
      },
      "signature": "MEYCIQC10G/aXugxkimB4QBvBuG+LTa36bVqG1OYXJd+4qsjmQIhAJjLDgRQ1aL+3TW+G1WGNVyCbXTFQZ5Hn8Vw6i77qqrN"
    }
    """.data(using: .utf8)!
    
    static let dataDoesNotMatchSignature: Data =
    """
    {
      "platform": "iOS",
      "config": {
        "available": true,
        "minimumVersion": "0.0.1",
        "recommendedVersion": "0.0.1",
        "releaseFlags": {
          "onboarding": true,
          "search": false,
          "topics": false,
          "recentActivity": true
        },
        "version": "0.0.5",
        "lastUpdated": "2024-10-30T09:55:51.351Z"
      },
      "signature": "MEYCIQC10G/aXugxkimB4QBvBuG+LTa36bVqG1OYXJd+4qsjmQIhAJjLDgRQ1aL+3TW+G1WGNVyCbXTFQZ5Hn8Vw6i77qqrN"
    }
    """.data(using: .utf8)!
}
