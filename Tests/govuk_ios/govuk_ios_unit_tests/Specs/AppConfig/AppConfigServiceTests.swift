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
        let result = ["search": true].toResult()
        mockAppConfigRepository._receivedFetchAppConfigCompletion?(result)
        //Then
        XCTAssertTrue(sut.isFeatureEnabled(key: .search))
    }

    func test_repository_isFeatureEnabled_whenFeatureFlagIsSetToUnavailable_returnsFalse() throws {
        //When
        let result = ["search": false].toResult()
        mockAppConfigRepository._receivedFetchAppConfigCompletion?(result)
        //Then
        XCTAssertFalse(sut.isFeatureEnabled(key: .search))
    }

    func test_repository_isFeatureEnabled_whenFeatureFlagIsNotInConfig_returnsFalse() throws {
        //When
        let result = ["test": false].toResult()
        mockAppConfigRepository._receivedFetchAppConfigCompletion?(result)
        //Then
        XCTAssertFalse(sut.isFeatureEnabled(key: .search))
    }

    func test_serviceClient_isFeatureEnabled_whenFeatureFlagIsSetToAvailable_returnsTrue() throws {
        //When
        let result = ["search": true].toResult()
        mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(result)
        //Then
        XCTAssertTrue(sut.isFeatureEnabled(key: .search))
    }

    func test_serviceClient_isFeatureEnabled_whenFeatureFlagIsSetToUnavailable_returnsFalse() throws {
        //When
        let result = ["search": false].toResult()
        mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(result)
        //Then
        XCTAssertFalse(sut.isFeatureEnabled(key: .search))
    }

    func test_serviceClient_isFeatureEnabled_whenFeatureFlagIsNotInConfig_returnsFalse() throws {
        //When
        let result = ["test": false].toResult()
        mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(result)
        //Then
        XCTAssertFalse(sut.isFeatureEnabled(key: .search))
    }
}

private extension [String:Bool] {
    func toResult() -> Result<AppConfig, AppConfigError> {
        let config = Config.arrange(releaseFlags: self)
        let appConfig = AppConfig.arrange(
            config: config
        )
        return .success(appConfig)
    }
}
