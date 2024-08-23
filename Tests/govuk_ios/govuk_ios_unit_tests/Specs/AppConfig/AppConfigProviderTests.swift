@testable import govuk_ios
import XCTest

final class AppConfigProviderTests: XCTestCase {
    var sut: AppConfigProvider?

    override func setUpWithError() throws {
         sut = AppConfigProvider()
    }

    override func tearDownWithError() throws {
         sut = nil
    }

    func testFetchAppConfig_vaidFileName_returnsCorrect_Config() throws {
        guard let sut = sut else { return }
        sut.fetchAppConfig(filename: "MockAppConfigResponse") { result in
            let config = try? result.get()
            XCTAssertEqual(config?.config.releaseFlags.count, 2)
            if let searchFeatureflag = config?.config.releaseFlags["search"] {
                XCTAssertEqual(searchFeatureflag, true)
            } else {
                XCTFail()
            }
        }
    }
    
    func test_fetchAppConfig_invalidFileName_returnsError() throws {
        guard let sut = sut else { return }
        sut.fetchAppConfig(filename: "MockResponseInvalidFileName") { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(_):
                XCTAssertTrue(true)
            }
        }
    }
    
    func test_testFetchAppConfig_invalidFileJson_returnsError() throws {
        guard let sut = sut else { return }
        sut.fetchAppConfig(filename: "MockAppConfigResponseInvalid") { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(_):
                XCTAssertTrue(true)
            }
        }
    }
}
