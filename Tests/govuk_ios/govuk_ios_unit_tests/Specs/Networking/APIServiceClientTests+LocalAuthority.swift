import Foundation
import Testing
import GOVKit
@testable import govuk_ios

@Suite(.serialized)
struct APIServiceClientTests_LocalAuthority {
    @Test
    func send_successResponse_returnsExpectedResult() async {
        let subject = APIServiceClient(
            baseUrl: URL(string: "https://www.google.com")!,
            session: URLSession.mock,
            requestBuilder: RequestBuilder(),
            responseHandler: LocalAuthorityResponseHandler()

        )
        let request = GOVRequest.localAuthority(postcode: "E18QS")
        let expectedResponse = HTTPURLResponse.arrange(statusCode: 200)
        let expectedData = Data()
        MockURLProtocol.requestHandlers[
            "https://www.google.com/api/local-authority"
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
        [400,
         404,
         500],
        [LocalAuthorityError.invalidPostcode,
         .unknownPostcode,
         .apiUnavailable]
    ))
    func send_httpResponseError_returnsExpectedResult(
        statusCode: Int,
        authorityError: LocalAuthorityError
    ) async throws{
        let subject = APIServiceClient(
            baseUrl: URL(string: "https://www.google.com")!,
            session: URLSession.mock,
            requestBuilder: RequestBuilder(),
            responseHandler: LocalAuthorityResponseHandler()
        )
        let request = GOVRequest.localAuthority(postcode: "E18QS")
        let expectedResponse = HTTPURLResponse.arrange(statusCode: statusCode)
        MockURLProtocol.requestHandlers[
            "https://www.google.com/api/local-authority"
        ] = { request in
            return (expectedResponse, nil, nil)
        }

        let result = await withCheckedContinuation { continuation in
            subject.send(
                request: request,
                completion: { continuation.resume(returning: $0) }
            )
        }
        let error = try #require(result.getError() as? LocalAuthorityError)
        #expect(error == authorityError)
    }
}
