import XCTest

@testable import govuk_ios

final class AppConfigProviderTests: XCTestCase {
    var sut: AppConfigProvider!

    override func setUpWithError() throws {
        let apiService = APIServiceClient(
            baseUrl: URL(string: Constants.API.appConfigUrl)!,
            session: URLSession.mock,
            requestBuilder: RequestBuilder()
        )
        sut = AppConfigProvider(apiService: apiService)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_fetchLocalAppConfig_validFileName_returnsCorrectConfig() throws {
        sut.fetchLocalAppConfig(
            filename: "MockAppConfigResponse",
            completion: { result in
                let config = try? result.get()
                XCTAssertEqual(config?.config.releaseFlags.count, 2)
                XCTAssertEqual(config?.config.releaseFlags["search"], true)
            }
        )
    }

    func test_fetchLocalAppConfig_invalidFileName_returnsError() throws {
        sut.fetchLocalAppConfig(
            filename: "MockResponseInvalidFileName",
            completion: { result in
                switch result {
                case .success(let value):
                    XCTFail("Expected failure, got \(value)")
                case .failure:
                    XCTAssertTrue(true)
                }
            }
        )
    }

    func test_fetchLocalAppConfig_invalidFileJson_returnsError() throws {
        sut.fetchLocalAppConfig(
            filename: "MockAppConfigResponseInvalid",
            completion: { result in
                switch result {
                case .success(let value):
                    XCTFail("Expected failure, got \(value)")
                case .failure(_):
                    XCTAssertTrue(true)
                }
            }
        )
    }

    func test_fetchRemoteAppConfig_validJson_returnsCorrectConfig() throws {
        let expectedResponse = HTTPURLResponse.arrange(statusCode: 200)
        let mockJsonData = getJsonData(filename: "MockAppConfigResponse", bundle: .main)
        let expectation = expectation()
        MockURLProtocol.requestHandlers["https://app.integration.publishing.service.gov.uk/appinfo/ios"] = { request in
            return (expectedResponse, mockJsonData, nil)
        }
        sut.fetchRemoteAppConfig(
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

    func test_fetchRemoteAppConfig_invalidJson_returnsError() throws {
        let expectedResponse = HTTPURLResponse.arrange(statusCode: 200)
        let mockJsonData = getJsonData(filename: "MockAppConfigResponseInvalid", bundle: .main)
        let expectation = expectation()
        MockURLProtocol.requestHandlers["https://app.integration.publishing.service.gov.uk/appinfo/ios"] = { request in
            return (expectedResponse, mockJsonData, nil)
        }
        sut.fetchRemoteAppConfig(
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

    func test_fetchRemoteAppConfig_nilData_returnsError() throws {
        let expectedResponse = HTTPURLResponse.arrange(statusCode: 200)
        let expectation = expectation()
        MockURLProtocol.requestHandlers["https://app.integration.publishing.service.gov.uk/appinfo/ios"] = { request in
            return (expectedResponse, nil, nil)
        }
        sut.fetchRemoteAppConfig(
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



