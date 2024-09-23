import XCTest

@testable import govuk_ios

final class AppConfigServiceTests: XCTestCase {
    
    func test_repository_isFeatureEnabled_whenFeatureFlagIsSetToAvailable_returnsTrue() throws {
        //Given
        let mockAppConfigRepository = MockAppConfigRepository()
        let mockAppConfigServiceClient = MockAppConfigServiceClient()
        let sut = AppConfigService(appConfigRepository: mockAppConfigRepository,
                                   appConfigServiceClient: mockAppConfigServiceClient)
        //When
        let config = Config.arrange(releaseFlags: ["search": true])
        let appConfig = AppConfig.arrange(
            config: config
        )
        let result: Result<AppConfig, AppConfigError> = .success(appConfig)
        mockAppConfigRepository._receivedAppConfigCompletion?(result)
        //Then
        XCTAssertTrue(sut.isFeatureEnabled(key: .search))
    }
    
    func test_repository_isFeatureEnabled_whenFeatureFlagIsSetToUnavailable_returnsFalse() throws {
        //Given
        let mockAppConfigRepository = MockAppConfigRepository()
        let mockAppConfigServiceClient = MockAppConfigServiceClient()
        let sut = AppConfigService(appConfigRepository: mockAppConfigRepository,
                                   appConfigServiceClient: mockAppConfigServiceClient)
        //When
        let config = Config.arrange(releaseFlags: ["search": false])
        let appConfig = AppConfig.arrange(
            config: config
        )
        let result: Result<AppConfig, AppConfigError> = .success(appConfig)
        mockAppConfigRepository._receivedAppConfigCompletion?(result)
        //Then
        XCTAssertFalse(sut.isFeatureEnabled(key: .search))
    }
    
    func test_repository_isFeatureEnabled_whenFeatureFlagIsNotInConfig_returnsFalse() throws {
        //Given
        let mockAppConfigRepository = MockAppConfigRepository()
        let mockAppConfigServiceClient = MockAppConfigServiceClient()
        let sut = AppConfigService(appConfigRepository: mockAppConfigRepository,
                                   appConfigServiceClient: mockAppConfigServiceClient)
        //When
        let config = Config.arrange(releaseFlags: ["test": false])
        let appConfig = AppConfig.arrange(
            config: config
        )
        let result: Result<AppConfig, AppConfigError> = .success(appConfig)
        mockAppConfigRepository._receivedAppConfigCompletion?(result)
        //Then
        XCTAssertFalse(sut.isFeatureEnabled(key: .search))
    }

    func test_serviceClient_isFeatureEnabled_whenFeatureFlagIsSetToAvailable_returnsTrue() throws {
        //Given
        let mockAppConfigRepository = MockAppConfigRepository()
        let mockAppConfigServiceClient = MockAppConfigServiceClient()
        let sut = AppConfigService(appConfigRepository: mockAppConfigRepository,
                                   appConfigServiceClient: mockAppConfigServiceClient)
        //When
        let config = Config.arrange(releaseFlags: ["search": true])
        let appConfig = AppConfig.arrange(
            config: config
        )
        let result: Result<AppConfig, AppConfigError> = .success(appConfig)
        mockAppConfigServiceClient._receivedAppConfigCompletion?(result)
        //Then
        XCTAssertTrue(sut.isFeatureEnabled(key: .search))
    }

    func test_serviceClient_isFeatureEnabled_whenFeatureFlagIsSetToUnavailable_returnsFalse() throws {
        //Given
        let mockAppConfigRepository = MockAppConfigRepository()
        let mockAppConfigServiceClient = MockAppConfigServiceClient()
        let sut = AppConfigService(appConfigRepository: mockAppConfigRepository,
                                   appConfigServiceClient: mockAppConfigServiceClient)
        //When
        let config = Config.arrange(releaseFlags: ["search": false])
        let appConfig = AppConfig.arrange(
            config: config
        )
        let result: Result<AppConfig, AppConfigError> = .success(appConfig)
        mockAppConfigServiceClient._receivedAppConfigCompletion?(result)
        //Then
        XCTAssertFalse(sut.isFeatureEnabled(key: .search))
    }

    func test_serviceClient_isFeatureEnabled_whenFeatureFlagIsNotInConfig_returnsFalse() throws {
        //Given
        let mockAppConfigRepository = MockAppConfigRepository()
        let mockAppConfigServiceClient = MockAppConfigServiceClient()
        let sut = AppConfigService(appConfigRepository: mockAppConfigRepository,
                                   appConfigServiceClient: mockAppConfigServiceClient)
        //When
        let config = Config.arrange(releaseFlags: ["test": false])
        let appConfig = AppConfig.arrange(
            config: config
        )
        let result: Result<AppConfig, AppConfigError> = .success(appConfig)
        mockAppConfigServiceClient._receivedAppConfigCompletion?(result)
        //Then
        XCTAssertFalse(sut.isFeatureEnabled(key: .search))
    }
}
