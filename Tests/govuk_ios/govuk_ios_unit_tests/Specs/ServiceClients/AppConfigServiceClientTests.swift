import XCTest

@testable import govuk_ios

final class AppConfigServiceClientTests: XCTestCase {
    var sut: AppConfigServiceClient!
    var mockServiceClient: MockAPIServiceClient!

    override func setUpWithError() throws {
        mockServiceClient = MockAPIServiceClient()
        sut = AppConfigServiceClient(
            serviceClient: mockServiceClient
        )
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_fetchAppConfig_validJson_returnsCorrectConfig() throws {
        let mockJsonData = getJsonData(filename: "MockAppConfigResponse", bundle: .main)
        let expectation = expectation()
        sut.fetchAppConfig(
            completion: { result in
                switch result {
                case .success:
                    let resultData = try? result.get()
                    XCTAssertEqual(resultData?.config.releaseFlags.count, 2)
                    XCTAssertEqual(resultData?.config.releaseFlags["search"], true)
                case .failure:
                    XCTAssertTrue(false)
                }
                expectation.fulfill()
            }
        )
        mockServiceClient._receivedSendCompletion?(.success(mockJsonData))
        wait(for: [expectation], timeout: 1)
    }

    func test_fetchAppConfig_invalidJson_returnsError() throws {
        let expectation = expectation()
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
        mockServiceClient._receivedSendCompletion?(.failure(TestError.fakeNetwork))
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

