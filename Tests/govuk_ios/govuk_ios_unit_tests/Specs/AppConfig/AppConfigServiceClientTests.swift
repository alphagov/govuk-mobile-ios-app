import XCTest

@testable import govuk_ios

final class AppConfigServiceClientTests: XCTestCase {
    var sut: AppConfigServiceClient!

    override func setUpWithError() throws {
        let serviceClient = APIServiceClient(
            baseUrl: URL(string: Constants.API.appBaseUrl)!,
            session: URLSession.mock,
            requestBuilder: RequestBuilder()
        )
        sut = AppConfigServiceClient(serviceClient: serviceClient)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_fetchAppConfig_validJson_returnsCorrectConfig() throws {
        let expectedResponse = HTTPURLResponse.arrange(statusCode: 200)
        let mockJsonData = getJsonData(filename: "MockAppConfigResponse", bundle: .main)
        let expectation = expectation()
        MockURLProtocol.requestHandlers["https://app.integration.publishing.service.gov.uk/appinfo/ios"] = { request in
            return (expectedResponse, mockJsonData, nil)
        }
        sut.fetchAppConfig(
            completion: { result in
                switch result {
                case .success:
                    let resultData = try? result.get()
                    XCTAssertEqual(resultData?.config.releaseFlags.count, 2)
                    XCTAssertEqual(resultData?.config.releaseFlags["search"], true)
                case .failure(_):
                    XCTAssertTrue(false)
                }
                expectation.fulfill()
            }
        )
        wait(for: [expectation], timeout: 1)
    }

    func test_fetchAppConfig_invalidJson_returnsError() throws {
        let expectedResponse = HTTPURLResponse.arrange(statusCode: 200)
        let mockJsonData = getJsonData(filename: "MockAppConfigResponseInvalid", bundle: .main)
        let expectation = expectation()
        MockURLProtocol.requestHandlers["https://app.integration.publishing.service.gov.uk/appinfo/ios"] = { request in
            return (expectedResponse, mockJsonData, nil)
        }
        sut.fetchAppConfig(
            completion: { result in
                switch result {
                case .success(let value):
                    XCTFail("Expected failure, got \(value)")
                case .failure(_):
                    XCTAssertTrue(true)
                }
                expectation.fulfill()
            }
        )
        wait(for: [expectation], timeout: 1)
    }

    func test_fetchAppConfig_nilData_returnsError() throws {
        let expectedResponse = HTTPURLResponse.arrange(statusCode: 200)
        let expectation = expectation()
        MockURLProtocol.requestHandlers["https://app.integration.publishing.service.gov.uk/appinfo/ios"] = { request in
            return (expectedResponse, nil, nil)
        }
        sut.fetchAppConfig(
            completion: { result in
                switch result {
                case .success(let value):
                    XCTFail("Expected failure, got \(value)")
                case .failure(_):
                    XCTAssertTrue(true)
                }
                expectation.fulfill()
            }
        )
        wait(for: [expectation], timeout: 1)
    }

    private func getJsonData(filename: String, bundle: Bundle) -> Data {
        let resourceURL = bundle.url(
            forResource: filename,
            withExtension: "json"
        )
        guard let resourceURL = resourceURL else {
            return Data()
        }
        do {
            return try Data(contentsOf: resourceURL)
        } catch {
            return Data()
        }
    }
}

