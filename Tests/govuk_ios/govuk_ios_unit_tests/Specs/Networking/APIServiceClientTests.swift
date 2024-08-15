import Foundation
import XCTest

@testable import govuk_ios

class APIServiceClientTests: XCTestCase {

    func test_send_post_withParameters_passesExpectedValues() throws {
        let subject = APIServiceClient(
            baseUrl: URL(string: "https://www.google.com")!,
            session: URLSession.mock,
            requestBuilder: RequestBuilder()
        )
        let govRequest = GOVRequest(
            urlPath: "/test/test",
            method: .post,
            data: nil,
            parameters: ["test_key": "test_value"],
            queryParameters: nil,
            additionalHeaders: nil
        )
        let expectation = expectation()
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.absoluteString, "https://www.google.com/test/test")
            XCTAssertEqual(request.httpMethod, "POST")
            let data = request.bodySteamData
            XCTAssertNotNil(data)
            let json = try JSONDecoder().decode([String: String].self, from: data!)
            XCTAssertEqual(json["test_key"], "test_value")
            return (.arrangeSuccess, nil)
        }
        subject.send(
            request: govRequest,
            completion: { result in
                expectation.fulfill()
            }
        )
        wait(for: [expectation], timeout: 1)
    }

    func test_send_get_passesExpectedValues() {
        let subject = APIServiceClient(
            baseUrl: URL(string: "https://www.google.com")!,
            session: URLSession.mock,
            requestBuilder: RequestBuilder()
        )
        let request = GOVRequest(
            urlPath: "/test/123",
            method: .get,
            data: nil,
            parameters: nil,
            queryParameters: ["query": "value"],
            additionalHeaders: nil
        )
        let expectation = expectation()
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.absoluteString, "https://www.google.com/test/123?query=value")
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertNil(request.httpBody)
            return (.arrangeSuccess, nil)
        }
        subject.send(
            request: request,
            completion: { result in
                expectation.fulfill()
            }
        )
        wait(for: [expectation], timeout: 1)
    }

    func test_send_200_returnsExpectedResult() {
        let subject = APIServiceClient(
            baseUrl: URL(string: "https://www.google.com")!,
            session: URLSession.mock,
            requestBuilder: RequestBuilder()
        )
        let request = GOVRequest(
            urlPath: "/test/123",
            method: .get,
            data: nil,
            parameters: nil,
            queryParameters: nil,
            additionalHeaders: nil
        )
        let expectation = expectation()
        let expectedResponse = HTTPURLResponse.arrange(statusCode: 200)
        let expectedData = Data()
        MockURLProtocol.requestHandler = { request in
            return (expectedResponse, expectedData)
        }
        subject.send(
            request: request,
            completion: { result in
                let resultData = try? result.get()
                XCTAssertEqual(resultData, expectedData)
                expectation.fulfill()
            }
        )
        wait(for: [expectation], timeout: 1)
    }

    func test_send_failure_returnsExpectedResult() {
        let subject = APIServiceClient(
            baseUrl: URL(string: "https://www.google.com")!,
            session: URLSession.mock,
            requestBuilder: RequestBuilder()
        )
        let request = GOVRequest(
            urlPath: "/test/123",
            method: .get,
            data: nil,
            parameters: nil,
            queryParameters: nil,
            additionalHeaders: nil
        )
        let expectation = expectation()
        let expectedError = TestError.fakeNetwork
        MockURLProtocol.requestHandler = { request in
            throw expectedError
        }
        subject.send(
            request: request,
            completion: { result in
                switch result {
                case .failure(let error):
                    XCTAssertEqual(error as? TestError, expectedError)
                default:
                    XCTFail("Expected failure")
                }
                expectation.fulfill()
            }
        )
        wait(for: [expectation], timeout: 1)
    }
}

enum TestError: Error {
    case fakeNetwork
}
