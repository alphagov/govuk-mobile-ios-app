import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
struct AppConfigServiceTests {
    private var sut: AppConfigService!
    private var mockAppConfigServiceClient: MockAppConfigServiceClient!

    init() {
        mockAppConfigServiceClient = MockAppConfigServiceClient()
        sut = AppConfigService(
            appConfigServiceClient: mockAppConfigServiceClient
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
    func fetchAppConfig_missingPolligInterval_setsDefaultValue() async {
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
    func fetchAppConfig_zeroPolligInterval_setsDefaultValue() async {
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
