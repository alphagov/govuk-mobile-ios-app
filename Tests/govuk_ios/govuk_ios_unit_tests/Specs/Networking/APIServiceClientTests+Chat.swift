import Foundation
import Testing
import GOVKit
@testable import govuk_ios

@Suite(.serialized)
struct APIServiceClientTests_Chat {

    @Test
    func send_chatRequest_passesExpectedValues() async {
        let subject = APIServiceClient(
            baseUrl: URL(string: "https://www.google.com")!,
            session: URLSession.mock,
            requestBuilder: RequestBuilder(),
            responseHandler: ChatResponseHandler()

        )
        let request = GOVRequest.askQuestion("What is your quest?",
                                             accessToken: "testToken")

        MockURLProtocol.requestHandlers["https://www.google.com/conversation/"] = { request in
            #expect(request.httpMethod == "POST")
            #expect(request.allHTTPHeaderFields?["Content-Type"] == "application/json")
            #expect(request.allHTTPHeaderFields?["Authorization"] == "Bearer testToken")
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

    @Test
    func send_successResponse_returnsExpectedResult() async {
        let subject = APIServiceClient(
            baseUrl: URL(string: "https://www.google.com")!,
            session: URLSession.mock,
            requestBuilder: RequestBuilder(),
            responseHandler: ChatResponseHandler()

        )
        let request = GOVRequest.askQuestion("What is your quest?")
        let expectedResponse = HTTPURLResponse.arrange(statusCode: 200)
        let expectedData = Data()
        MockURLProtocol.requestHandlers[
            "https://www.google.com/conversation/"
        ] = { request in
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

    @Test(arguments: zip(
        [422,
         429,
         500],
        [ChatError.validationError,
         .apiUnavailable,
         .apiUnavailable]
    ))
    func send_httpResponseError_returnsExpectedResult(
        statusCode: Int,
        chatError: ChatError
    ) async throws{
        let subject = APIServiceClient(
            baseUrl: URL(string: "https://www.google.com")!,
            session: URLSession.mock,
            requestBuilder: RequestBuilder(),
            responseHandler: ChatResponseHandler()
        )
        let request = GOVRequest.askQuestion("What is your quest?")
        let expectedResponse = HTTPURLResponse.arrange(statusCode: statusCode)
        MockURLProtocol.requestHandlers[
            "https://www.google.com/conversation/"
        ] = { request in
            return (expectedResponse, nil, nil)
        }

        let result = await withCheckedContinuation { continuation in
            subject.send(
                request: request,
                completion: { continuation.resume(returning: $0) }
            )
        }
        let error = try #require(result.getError() as? ChatError)
        #expect(error == chatError)
    }
}
