import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
struct AppConfigServiceTests {
    private var sut: AppConfigService!
    private var mockAppConfigServiceClient: MockAppConfigServiceClient!
    private var mockAppVersionProvider: MockAppVersionProvider!

    init() {
        mockAppConfigServiceClient = MockAppConfigServiceClient()
        mockAppVersionProvider = MockAppVersionProvider()
        sut = AppConfigService(
            appConfigServiceClient: mockAppConfigServiceClient,
            appVersionProvider: mockAppVersionProvider
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
