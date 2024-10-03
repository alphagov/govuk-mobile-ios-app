import Foundation
import XCTest

@testable import govuk_ios

class APIServiceClientTestsXC: XCTestCase {

    func test_send_post_withParameters_passesExpectedValues() throws {
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
        let expectation = expectation()
        MockURLProtocol.requestHandlers["https://www.google.com/test/test"] = { request in
            XCTAssertEqual(request.url?.absoluteString, "https://www.google.com/test/test")
            XCTAssertEqual(request.httpMethod, "POST")
            let data = request.bodySteamData
            XCTAssertNotNil(data)
            let json = try? JSONDecoder().decode([String: String].self, from: data!)
            XCTAssertEqual(json?["test_key"], "test_value")
            return (.arrangeSuccess, nil, nil)
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
            urlPath: "/test/111",
            method: .get,
            bodyParameters: nil,
            queryParameters: ["query": "value"],
            additionalHeaders: nil
        )
        let expectation = expectation()
        MockURLProtocol.requestHandlers["https://www.google.com/test/111?query=value"] = { request in
            XCTAssertEqual(request.url?.absoluteString, "https://www.google.com/test/111?query=value")
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertNil(request.httpBody)
            return (.arrangeSuccess, nil, nil)
        }
        subject.send(
            request: request,
            completion: { result in
                expectation.fulfill()
            }
        )
        wait(for: [expectation], timeout: 1)
    }

    func test_send_successResponse_returnsExpectedResult() {
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
        let expectation = expectation()
        let expectedResponse = HTTPURLResponse.arrange(statusCode: 200)
        let expectedData = Data()
        MockURLProtocol.requestHandlers["https://www.google.com/test/222"] = { request in
            return (expectedResponse, expectedData, nil)
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

    func test_send_successResponse_noData_returnsExpectedResult() {
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
        let expectation = expectation()
        let expectedResponse = HTTPURLResponse.arrange(statusCode: 200)
        MockURLProtocol.requestHandlers["https://www.google.com/test/333"] = { request in
            return (expectedResponse, nil, nil)
        }
        subject.send(
            request: request,
            completion: { result in
                let resultData = try? result.get()
                XCTAssertNotNil(resultData)
                expectation.fulfill()
            }
        )
        wait(for: [expectation], timeout: 1)
    }

    func test_send_failureResponse_returnsExpectedResult() {
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
        let expectation = expectation()
        let expectedError = TestError.fakeNetwork
        MockURLProtocol.requestHandlers["https://www.google.com/test/444"] = { request in
            let expectedResponse = HTTPURLResponse.arrange(statusCode: 400)
            return (expectedResponse, nil, expectedError)
        }
        subject.send(
            request: request,
            completion: { result in
                switch result {
                case .failure:
                    break
                default:
                    XCTFail("Expected failure")
                }
                expectation.fulfill()
            }
        )
        wait(for: [expectation], timeout: 1)
    }
}
