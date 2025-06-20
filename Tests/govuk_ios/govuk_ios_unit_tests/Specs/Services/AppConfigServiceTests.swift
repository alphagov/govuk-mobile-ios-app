import Foundation
import UIKit
import Testing
import GOVKit

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
    func fetchAppConfig_containsAuthCreds_setsCreds() async throws {
        Constants.API.remoteAuthenticationURL = nil
        Constants.API.remoteAuthenticationClientID = nil
        _ = await withCheckedContinuation { continuation in
            sut.fetchAppConfig(completion: continuation.resume)
            let result = Config.arrange(
                authenticationIssuerBaseUrl: "https:/www.test.com",
                authenticationIssuerClientId: "test123"
            ).toResult()
            mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(result)
        }

        #expect(Constants.API.remoteAuthenticationURL?.absoluteString == "https:/www.test.com")
        #expect(Constants.API.remoteAuthenticationClientID == "test123")
    }

    @Test
    func fetchAppConfig_noAuthCreds_doesntSetCreds() async throws {
        Constants.API.remoteAuthenticationURL = nil
        Constants.API.remoteAuthenticationClientID = nil
        _ = await withCheckedContinuation { continuation in
            sut.fetchAppConfig(completion: continuation.resume)
            let result = Config.arrange(
                authenticationIssuerBaseUrl: nil,
                authenticationIssuerClientId: nil
            ).toResult()
            mockAppConfigServiceClient._receivedFetchAppConfigCompletion?(result)
        }

        #expect(Constants.API.remoteAuthenticationClientID == nil)
        #expect(Constants.API.remoteAuthenticationURL == nil)
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
