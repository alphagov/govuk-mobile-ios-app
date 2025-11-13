import Foundation
import UIKit
import Testing

@testable import govuk_ios


@Suite
struct AppConfigServiceTests {
    private var sut: AppConfigService!
    private var mockAppConfigServiceClient: MockAppConfigServiceClient!
    private var mockAnalyticsService: MockAnalyticsService!

    init() {
        mockAppConfigServiceClient = MockAppConfigServiceClient()
        mockAnalyticsService = MockAnalyticsService()
        sut = AppConfigService(
            appConfigServiceClient: mockAppConfigServiceClient,
            analyticsService: mockAnalyticsService
        )
    }

    @Test
    func fetchAppConfig_invalidSignatureError_setsForUpdate() async {
        let result = await withCheckedContinuation { continuation in
            sut.fetchAppConfig(completion: continuation.resume)
            mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(
                .failure(.invalidSignature)
            )
        }

        #expect(result.getError() == .invalidSignature)
        #expect(mockAnalyticsService._trackErrorReceivedErrors.count == 1)
    }

    @Test
    func fetchAppConfig_existingConfigValue_replacesValue() async {
        let configResult = Config.arrange(releaseFlags: [Feature.search.rawValue: false])
        _ = await withCheckedContinuation { continuation in
            sut.fetchAppConfig(completion: continuation.resume)
            mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(
                configResult.toResult()
            )
        }

        let updatedConfigResult = Config.arrange(releaseFlags: [Feature.search.rawValue: true])
        _ = await withCheckedContinuation { continuation in
            sut.fetchAppConfig(completion: continuation.resume)
            mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(
                updatedConfigResult.toResult()
            )
        }

        #expect(sut.isFeatureEnabled(key: .search))
    }

    @Test
    func fetchAppConfig_updatesChatPollingInterval() async {
        let configResult = Config.arrange(chatPollIntervalSeconds: 10).toResult()
        _ = await withCheckedContinuation { continuation in
            sut.fetchAppConfig(completion: continuation.resume)
            mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(
                configResult
            )
        }

        #expect(sut.chatPollIntervalSeconds == 10.0)
    }

    @Test
    func fetchAppConfig_missingPollingInterval_setsDefaultValue() async {
        let configResult = Config.arrange(chatPollIntervalSeconds: nil).toResult()
        _ = await withCheckedContinuation { continuation in
            sut.fetchAppConfig(completion: continuation.resume)
            mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(
                configResult
            )
        }

        #expect(sut.chatPollIntervalSeconds == 3.0)
    }

    @Test
    func fetchAppConfig_updatesRefreshTokenExpiry() async throws {
        let stubbedResult = Config.arrange(refreshTokenExpirySeconds: 5)
        let result = await withCheckedContinuation { continuation in
            sut.fetchAppConfig(completion: continuation.resume)
            mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(
                stubbedResult.toResult()
            )
        }
        #expect(try result.get().config.refreshTokenExpirySeconds == stubbedResult.refreshTokenExpirySeconds)

        mockAppConfigServiceClient._receivedFetchAppConfigCompletion = nil
        let stubbedResultTwo = Config.arrange(refreshTokenExpirySeconds: nil)
        let resultTwo = await withCheckedContinuation { continuation in
            sut.fetchAppConfig(completion: continuation.resume)
            mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(
                stubbedResultTwo.toResult()
            )
        }
        #expect(try resultTwo.get().config.refreshTokenExpirySeconds == stubbedResultTwo.refreshTokenExpirySeconds)

        mockAppConfigServiceClient._receivedFetchAppConfigCompletion = nil
        let stubbedResultThree = Config.arrange(refreshTokenExpirySeconds: 10)
        let resultThree = await withCheckedContinuation { continuation in
            sut.fetchAppConfig(completion: continuation.resume)
            mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(
                stubbedResultThree.toResult()
            )
        }
        #expect(try resultThree.get().config.refreshTokenExpirySeconds == stubbedResultThree.refreshTokenExpirySeconds)

        mockAppConfigServiceClient._receivedFetchAppConfigCompletion = nil
        let stubbedResultFour = Config.arrange(refreshTokenExpirySeconds: 15)
        let resultFour = await withCheckedContinuation { continuation in
            sut.fetchAppConfig(completion: continuation.resume)
            mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(
                stubbedResultFour.toResult()
            )
        }
        #expect(try resultFour.get().config.refreshTokenExpirySeconds == stubbedResultFour.refreshTokenExpirySeconds)
    }

    @Test
    func fetchAppConfig_zeroPollingInterval_setsDefaultValue() async {
        let configResult = Config.arrange(chatPollIntervalSeconds: 0).toResult()
        _ = await withCheckedContinuation { continuation in
            sut.fetchAppConfig(completion: continuation.resume)
            mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(
                configResult
            )
        }

        #expect(sut.chatPollIntervalSeconds == 3.0)
    }

    @Test
    func isFeatureEnabled_whenFeatureFlagIsSetToAvailable_returnsTrue() {
        let result = Config.arrange(releaseFlags: ["search": true]).toResult()
        sut.fetchAppConfig(completion: { _ in })
        mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(result)

        #expect(sut.isFeatureEnabled(key: .search))
    }

    @Test
    func isFeatureEnabled_whenFeatureFlagIsSetToUnavailable_returnsFalse() {
        let result = Config.arrange(releaseFlags: ["search": false]).toResult()
        mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(result)

        #expect(sut.isFeatureEnabled(key: .search) == false)
    }

    @Test
    func isFeatureEnabled_whenFeatureFlagIsNotInConfig_returnsFalse() {
        let result = Config.arrange(releaseFlags: ["test": false]).toResult()
        mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(result)

        #expect(sut.isFeatureEnabled(key: .search) == false)
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
