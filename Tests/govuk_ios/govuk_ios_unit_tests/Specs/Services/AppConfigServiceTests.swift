import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
struct AppConfigServiceTests {
    private var sut: AppConfigService!
    private var mockAppConfigRepository: MockAppConfigRepository!
    private var mockAppConfigServiceClient: MockAppConfigServiceClient!
    private var mockAppVersionProvider: MockAppVersionProvider!

    init() {
        mockAppConfigRepository = MockAppConfigRepository()
        mockAppConfigServiceClient = MockAppConfigServiceClient()
        mockAppVersionProvider = MockAppVersionProvider()
        sut = AppConfigService(
            appConfigRepository: mockAppConfigRepository,
            appConfigServiceClient: mockAppConfigServiceClient,
            appVersionProvider: mockAppVersionProvider
        )
        sut.fetchAppConfig {}
    }

    @Test
    func fetchAppConfig_invalidSignatureError_setsForUpdate() {
        mockAppConfigRepository._receivedFetchAppConfigCompletion?(.failure(.invalidSignature))

        #expect(sut.isAppForcedUpdate)
    }

    @Test
    func fetchAppConfig_loadJsonError_setsAppUnavailable() {
        mockAppConfigRepository._receivedFetchAppConfigCompletion?(.failure(.loadJson))

        #expect(!sut.isAppAvailable)
    }

    @Test
    func fetchAppConfig_remoteJsonError_returnsError() {
        mockAppConfigRepository._receivedFetchAppConfigCompletion?(.failure(.remoteJson))

        #expect(!sut.isAppAvailable)
    }

    @Test
    func repository_isFeatureEnabled_whenFeatureFlagIsSetToAvailable_returnsTrue() {
        let result = Config.arrange(releaseFlags: ["search": true]).toResult()
        mockAppConfigRepository._receivedFetchAppConfigCompletion?(result)

        #expect(sut.isFeatureEnabled(key: .search))
    }

    @Test
    func repository_isFeatureEnabled_whenFeatureFlagIsSetToUnavailable_returnsFalse() {
        let result = Config.arrange(releaseFlags: ["search": false]).toResult()
        mockAppConfigRepository._receivedFetchAppConfigCompletion?(result)

        #expect(sut.isFeatureEnabled(key: .search) == false)
    }

    @Test
    func repository_isFeatureEnabled_whenFeatureFlagIsNotInConfig_returnsFalse() {
        let result = Config.arrange(releaseFlags: ["test": false]).toResult()
        mockAppConfigRepository._receivedFetchAppConfigCompletion?(result)

        #expect(sut.isFeatureEnabled(key: .search) == false)
    }

    @Test
    func repository_isAppAvailable_whenAvailableIsTrueInConfig_returnsTrue() {
        let result = Config.arrange(available: true).toResult()
        mockAppConfigRepository._receivedFetchAppConfigCompletion?(result)

        #expect(sut.isAppAvailable)
    }

    @Test
    func repository_isAppAvailable_whenAvailableIsFalseInConfig_returnsFalse() {
        let result = Config.arrange(available: false).toResult()
        mockAppConfigRepository._receivedFetchAppConfigCompletion?(result)

        #expect(sut.isAppAvailable == false)
    }

    @Test
    func repository_isAppAvailable_whenFetchAppConfigFailure_returnsFalse() {
        let result: Result<AppConfig, AppConfigError> = .failure(.loadJson)
        mockAppConfigRepository._receivedFetchAppConfigCompletion?(result)

        #expect(sut.isAppAvailable == false)
    }

    @Test
    func repository_isAppForcedUpdate_whenAppVersionIsLessThanMinimumVersionInConfig_returnsTrue() {
        mockAppVersionProvider.versionNumber = "0.0.1"
        let result = Config.arrange(minimumVersion: "1.0.0").toResult()
        mockAppConfigRepository._receivedFetchAppConfigCompletion?(result)

        #expect(sut.isAppForcedUpdate == true)
    }

    @Test
    func repository_isAppForcedUpdate_whenAppVersionIsGreaterThanMinimumVersionInConfig_returnsFalse() {
        mockAppVersionProvider.versionNumber = "1.0.0"
        let result = Config.arrange(minimumVersion: "0.0.1").toResult()
        mockAppConfigRepository._receivedFetchAppConfigCompletion?(result)

        #expect(sut.isAppForcedUpdate == false)
    }

    @Test
    func repository_isAppRecommendUpdate_whenAppVersionIsLessThanRecommendedVersionInConfig_returnsTrue() {
        mockAppVersionProvider.versionNumber = "0.0.1"
        let result = Config.arrange(recommendedVersion: "1.0.0").toResult()
        mockAppConfigRepository._receivedFetchAppConfigCompletion?(result)

        #expect(sut.isAppRecommendUpdate == true)
    }

    @Test
    func repository_isAppRecommendUpdate_whenAppVersionIsLessThanRecommendedVersionInConfig_returnsFalse() {
        mockAppVersionProvider.versionNumber = "1.0.0"
        let result = Config.arrange(recommendedVersion: "0.0.1").toResult()
        mockAppConfigRepository._receivedFetchAppConfigCompletion?(result)

        #expect(sut.isAppRecommendUpdate == false)
    }

    @Test
    func serviceClient_isFeatureEnabled_whenFeatureFlagIsSetToAvailable_returnsTrue() {
        let result = Config.arrange(releaseFlags: ["search": true]).toResult()
        mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(result)

        #expect(sut.isFeatureEnabled(key: .search))
    }

    @Test
    func serviceClient_isFeatureEnabled_whenFeatureFlagIsSetToUnavailable_returnsFalse() {
        let result = Config.arrange(releaseFlags: ["search": false]).toResult()
        mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(result)

        #expect(sut.isFeatureEnabled(key: .search) == false)
    }

    @Test
    func serviceClient_isFeatureEnabled_whenFeatureFlagIsNotInConfig_returnsFalse() {
        let result = Config.arrange(releaseFlags: ["test": false]).toResult()
        mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(result)

        #expect(sut.isFeatureEnabled(key: .search) == false)
    }

    @Test
    func serviceClient_isAppAvailable_whenAvailableIsTrueInConfig_returnsTrue() {
        let result = Config.arrange(available: true).toResult()
        mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(result)

        #expect(sut.isAppAvailable)
    }

    @Test
    func serviceClient_isAppAvailable_whenAvailableIsFalseInConfig_returnsFalse() {
        let result = Config.arrange(available: false).toResult()
        mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(result)

        #expect(sut.isAppAvailable == false)
    }

    @Test
    func serviceClient_isAppAvailable_whenFetchAppConfigFailure_returnsFalse() {
        let result: Result<AppConfig, AppConfigError> = .failure(.remoteJson)
        mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(result)

        #expect(sut.isAppAvailable == false)
    }

    @Test
    func serviceClient_isAppForcedUpdate_whenAppVersionIsLessThanMinimumVersionInConfig_returnsTrue() {
        mockAppVersionProvider.versionNumber = "0.0.1"
        let result = Config.arrange(minimumVersion: "1.0.0").toResult()
        mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(result)

        #expect(sut.isAppForcedUpdate == true)
    }

    @Test
    func serviceClient_isAppForcedUpdate_whenAppVersionIsGreaterThanMinimumVersionInConfig_returnsFalse() {
        mockAppVersionProvider.versionNumber = "1.0.0"
        let result = Config.arrange(minimumVersion: "0.0.1").toResult()
        mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(result)

        #expect(sut.isAppForcedUpdate == false)
    }

    @Test
    func serviceClient_isAppRecommendUpdate_whenAppVersionIsLessThanRecommendedVersionInConfig_returnsTrue() {
        mockAppVersionProvider.versionNumber = "0.0.1"
        let result = Config.arrange(recommendedVersion: "1.0.0").toResult()
        mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(result)

        #expect(sut.isAppRecommendUpdate == true)
    }

    @Test
    func serviceClient_isAppRecommendUpdate_whenAppVersionIsLessThanRecommendedVersionInConfig_returnsFalse() {
        mockAppVersionProvider.versionNumber = "1.0.0"
        let result = Config.arrange(recommendedVersion: "0.0.1").toResult()
        mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(result)

        #expect(sut.isAppRecommendUpdate == false)
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
