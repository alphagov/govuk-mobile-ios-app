import Foundation
import XCTest

@testable import govuk_ios

class APIServiceClientTests: XCTestCase {

    func test_send_post_passesExpectedValues() {
        let mockSession = MockURLSession()
        let subject = APIServiceClient(
            baseUrl: URL(string: "https://www.google.com")!,
            session: URLSession.mock,
            requestBuilder: RequestBuilder()
        )
        let request = GOVRequest(
            urlPath: "/test/test",
            verb: .post,
            data: nil,
            parameters: nil,
            queryParameters: nil,
            additionalHeaders: nil
        )
        MockURLProtocol.requestHandler = { request in
            print(request.url?.absoluteString)
            return (.success, nil)
        }
        subject.send(
            request: request,
            completion: { result in

            }
        )

//        XCTAssertEqual(mockSession._requestReceivedURL?.absoluteString, "https://www.google.com/test/test")
//        XCTAssertEqual(mockSession._requestReceivedMethod, .post)
//        XCTAssertNil(mockSession._requestReceivedParameters)
    }
}

extension HTTPURLResponse {

    static var success: HTTPURLResponse {
        .init(
            url: URL(string: "www.google.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
    }
}
