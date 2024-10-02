import XCTest

@testable import govuk_ios

final class AppConfigServiceTests: XCTestCase {
    private var sut: AppConfigService!
    private var mockAppConfigRepository: MockAppConfigRepository!
    private var mockAppConfigServiceClient: MockAppConfigServiceClient!

    override func setUpWithError() throws {
        mockAppConfigRepository = MockAppConfigRepository()
        mockAppConfigServiceClient = MockAppConfigServiceClient()
        sut = AppConfigService(
            appConfigRepository: mockAppConfigRepository,
            appConfigServiceClient: mockAppConfigServiceClient
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        mockAppConfigRepository = nil
        mockAppConfigServiceClient = nil
    }

    func test_repository_isFeatureEnabled_whenFeatureFlagIsSetToAvailable_returnsTrue() throws {
        //When
        let result = Config.arrange(releaseFlags: ["search": true]).toResult()
        mockAppConfigRepository._receivedFetchAppConfigCompletion?(result)
        //Then
        XCTAssertTrue(sut.isFeatureEnabled(key: .search))
    }

    func test_repository_isFeatureEnabled_whenFeatureFlagIsSetToUnavailable_returnsFalse() throws {
        //When
        let result = Config.arrange(releaseFlags: ["search": false]).toResult()
        mockAppConfigRepository._receivedFetchAppConfigCompletion?(result)
        //Then
        XCTAssertFalse(sut.isFeatureEnabled(key: .search))
    }

    func test_repository_isFeatureEnabled_whenFeatureFlagIsNotInConfig_returnsFalse() throws {
        //When
        let result = Config.arrange(releaseFlags: ["test": false]).toResult()
        mockAppConfigRepository._receivedFetchAppConfigCompletion?(result)
        //Then
        XCTAssertFalse(sut.isFeatureEnabled(key: .search))
    }

    func test_repository_isAppAvailable_whenAvailableIsTrueInConfig_returnsTrue() throws {
        //When
        let result = Config.arrange(available: true).toResult()
        mockAppConfigRepository._receivedFetchAppConfigCompletion?(result)
        //Then
        XCTAssertTrue(sut.isAppAvailable)
    }

    func test_repository_isAppAvailable_whenAvailableIsFalseInConfig_returnsFalse() throws {
        //When
        let result = Config.arrange(available: false).toResult()
        mockAppConfigRepository._receivedFetchAppConfigCompletion?(result)
        //Then
        XCTAssertFalse(sut.isAppAvailable)
    }

    func test_serviceClient_isFeatureEnabled_whenFeatureFlagIsSetToAvailable_returnsTrue() throws {
        //When
        let result = Config.arrange(releaseFlags: ["search": true]).toResult()
        mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(result)
        //Then
        XCTAssertTrue(sut.isFeatureEnabled(key: .search))
    }

    func test_serviceClient_isFeatureEnabled_whenFeatureFlagIsSetToUnavailable_returnsFalse() throws {
        //When
        let result = Config.arrange(releaseFlags: ["search": false]).toResult()
        mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(result)
        //Then
        XCTAssertFalse(sut.isFeatureEnabled(key: .search))
    }

    func test_serviceClient_isFeatureEnabled_whenFeatureFlagIsNotInConfig_returnsFalse() throws {
        //When
        let result = Config.arrange(releaseFlags: ["test": false]).toResult()
        mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(result)
        //Then
        XCTAssertFalse(sut.isFeatureEnabled(key: .search))
    }

    func test_serviceClient_isAppAvailable_whenAvailableIsTrueInConfig_returnsTrue() throws {
        //When
        let result = Config.arrange(available: true).toResult()
        mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(result)
        //Then
        XCTAssertTrue(sut.isAppAvailable)
    }

    func test_serviceClient_isAppAvailable_whenAvailableIsFalseInConfig_returnsFalse() throws {
        //When
        let result = Config.arrange(available: false).toResult()
        mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(result)
        //Then
        XCTAssertFalse(sut.isAppAvailable)
    }
}

private extension Config {
    func toResult() -> Result<AppConfig, AppConfigError> {
        let appConfig = AppConfig.arrange(
            config: self
        )
        return .success(appConfig)
    }
}
