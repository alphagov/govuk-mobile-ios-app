import XCTest

@testable import govuk_ios

final class AppConfigServiceTests: XCTestCase {
    
    func test_isFeatureEnabled_whenFeatureFlagIsSetToAvilable_returnsTrue() throws {
        //Given
        let mockAppConfigProvider = MockAppConfigProvider()
        let sut = AppConfigService(configProvider: mockAppConfigProvider)
        //When
        let config = Config.arrange(releaseFlags: ["search": true])
        let appConfig = AppConfig.arrange(
            config: config
        )
        let result: Result<AppConfig, AppConfigError> = .success(appConfig)
        mockAppConfigProvider._receivedAppConfigCompletion?(result)
        //Then
        XCTAssertTrue(sut.isFeatureEnabled(key: .search))
    }
    
    func test_isFeatureEnabled_whenFeatureFlagIsSetToUnavilable_returnsFalse() throws {
        //Given
        let mockAppConfigProvider = MockAppConfigProvider()
        let sut = AppConfigService(configProvider: mockAppConfigProvider)
        //When
        let config = Config.arrange(releaseFlags: ["search": false])
        let appConfig = AppConfig.arrange(
            config: config
        )
        let result: Result<AppConfig, AppConfigError> = .success(appConfig)
        mockAppConfigProvider._receivedAppConfigCompletion?(result)
        //Then
        XCTAssertFalse(sut.isFeatureEnabled(key: .search))
    }
    
    func test_isFeatureEnabled_whenFeatureFlagIsNotInConfig_returnsFalse() throws {
        //Given
        let mockAppConfigProvider = MockAppConfigProvider()
        let sut = AppConfigService(configProvider: mockAppConfigProvider)
        //When
        let config = Config.arrange(releaseFlags: ["test": false])
        let appConfig = AppConfig.arrange(
            config: config
        )
        let result: Result<AppConfig, AppConfigError> = .success(appConfig)
        mockAppConfigProvider._receivedAppConfigCompletion?(result)
        //Then
        XCTAssertFalse(sut.isFeatureEnabled(key: .search))
    }
}