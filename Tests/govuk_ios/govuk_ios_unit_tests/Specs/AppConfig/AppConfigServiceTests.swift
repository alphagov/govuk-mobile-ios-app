@testable import govuk_ios
import XCTest

final class AppConfigServiceTests: XCTestCase {
    
    func test_isFeatureEnabled_whenFeatureFlagIsSetToAvilable_returnsTrue() throws {
        //Given
        let mockAppConfigProvider = MockAppConfigProvider()
        let sut = AppConfigService(configProvider: mockAppConfigProvider)
        //When
        mockAppConfigProvider._receivedAppConfigCompletion?(.success(AppConfig(platform: "",
                               config: Config(available: true, 
                               minimumVersion: "",
                               recommendedVersion: "",
                               releaseFlags: ["search": true],
                               lastUpdated: ""),
                               signature: "")
        )
        )
        //Then
        XCTAssertEqual(sut.isFeatureEnabled(key: .search), true)
    }
    
    func test_isFeatureEnabled_whenFeatureFlagIsSetToUnavilable_returnsFalse() throws {
        //Given
        let mockAppConfigProvider = MockAppConfigProvider()
        let sut = AppConfigService(configProvider: mockAppConfigProvider)
        //When
        mockAppConfigProvider._receivedAppConfigCompletion?(.success(AppConfig(platform: "",
                               config: Config(available: true, 
                               minimumVersion: "",
                               recommendedVersion: "",
                               releaseFlags: ["search": false],
                               lastUpdated: ""),
                               signature: "")))
        //Then
        XCTAssertEqual(sut.isFeatureEnabled(key: .search), false)
    }
    
    func test_isFeatureEnabled_whenFeatureFlagIsNotInConfig_returnsFalse() throws {
        //Given
        let mockAppConfigProvider = MockAppConfigProvider()
        let sut = AppConfigService(configProvider: mockAppConfigProvider)
        //When
        mockAppConfigProvider._receivedAppConfigCompletion?(.success(AppConfig(platform: "",
                               config: Config(available: true, 
                               minimumVersion: "",
                               recommendedVersion: "",
                               releaseFlags: ["test": false],
                               lastUpdated: ""),
                               signature: "")))
        //Then
        XCTAssertEqual(sut.isFeatureEnabled(key: .search), false)
    }
}
