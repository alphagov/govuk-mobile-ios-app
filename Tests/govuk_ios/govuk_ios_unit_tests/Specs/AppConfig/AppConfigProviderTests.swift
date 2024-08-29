import XCTest

@testable import govuk_ios

final class AppConfigProviderTests: XCTestCase {
    var sut: AppConfigProvider!

    override func setUpWithError() throws {
        sut = AppConfigProvider()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_fetchAppConfig_vaidFileName_returnsCorrectConfig() throws {
        sut.fetchAppConfig(
            filename: "MockAppConfigResponse",
            completion: { result in
                let config = try? result.get()
                XCTAssertEqual(config?.config.releaseFlags.count, 2)
                XCTAssertEqual(config?.config.releaseFlags["search"], true)
            }
        )
    }

    func test_fetchAppConfig_invalidFileName_returnsError() throws {
        sut.fetchAppConfig(
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

    func test_fetchAppConfig_invalidFileJson_returnsError() throws {
        sut.fetchAppConfig(
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
}

