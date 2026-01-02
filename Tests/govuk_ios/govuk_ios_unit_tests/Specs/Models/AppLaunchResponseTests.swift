import Foundation
import Testing

@testable import govuk_ios

@Suite
struct AppLaunchResponseTests {
    @Test
    func isAppAvailable_invalidSignature_returnsTrue() {
        let subject = AppLaunchResponse(
            configResult: .failure(.invalidSignature),
            topicResult: .success([]),
            notificationConsentResult: .aligned,
            remoteConfigFetchResult: .success,
            appVersionProvider: MockAppVersionProvider()
        )

        #expect(!subject.isAppAvailable)
    }

    @Test
    func isAppAvailable_unavailable_returnsTrue() {
        let subject = AppLaunchResponse(
            configResult: .success(.arrange(config: .arrange(available: false))),
            topicResult: .success([]),
            notificationConsentResult: .aligned,
            remoteConfigFetchResult: .success,
            appVersionProvider: MockAppVersionProvider()
        )

        #expect(!subject.isAppAvailable)
    }

    @Test
    func isUpdateRequired_lowerCurrentVersion_returnsTrue() {
        let currentVersion = "0.0.1"
        let config = Config.arrange(
            minimumVersion: "1.0.0"
        )
        let mockVersionProvider = MockAppVersionProvider()
        mockVersionProvider.versionNumber = currentVersion
        let subject = AppLaunchResponse(
            configResult: .success(.arrange(config: config)),
            topicResult: .success([]),
            notificationConsentResult: .aligned,
            remoteConfigFetchResult: .success,
            appVersionProvider: mockVersionProvider
        )

        #expect(subject.isUpdateRequired)
    }

    @Test
    func isUpdateRequired_sameCurrentVersion_returnsFalse() {
        let currentVersion = "1.0.0"
        let config = Config.arrange(
            minimumVersion: "1.0.0"
        )
        let mockVersionProvider = MockAppVersionProvider()
        mockVersionProvider.versionNumber = currentVersion
        let subject = AppLaunchResponse(
            configResult: .success(.arrange(config: config)),
            topicResult: .success([]),
            notificationConsentResult: .aligned,
            remoteConfigFetchResult: .success,
            appVersionProvider: mockVersionProvider
        )

        #expect(!subject.isUpdateRequired)
    }

    @Test
    func isUpdateRequired_higherCurrentVersion_returnsFalse() {
        let currentVersion = "1.0.1"
        let config = Config.arrange(
            minimumVersion: "1.0.0",
            recommendedVersion: "1.0.2"
        )
        let mockVersionProvider = MockAppVersionProvider()
        mockVersionProvider.versionNumber = currentVersion
        let subject = AppLaunchResponse(
            configResult: .success(.arrange(config: config)),
            topicResult: .success([]),
            notificationConsentResult: .aligned,
            remoteConfigFetchResult: .success,
            appVersionProvider: mockVersionProvider
        )

        #expect(!subject.isUpdateRequired)
    }

    @Test
    func isUpdateRequired_invalidSignature_returnsFalse() {
        let subject = AppLaunchResponse(
            configResult: .failure(.invalidSignature),
            topicResult: .success([]),
            notificationConsentResult: .aligned,
            remoteConfigFetchResult: .success,
            appVersionProvider: MockAppVersionProvider()
        )

        #expect(subject.isUpdateRequired)
    }

    @Test
    func isUpdateRequired_error_returnsFalse() {
        let subject = AppLaunchResponse(
            configResult: .failure(.remoteJson),
            topicResult: .failure(.apiUnavailable),
            notificationConsentResult: .aligned,
            remoteConfigFetchResult: .success,
            appVersionProvider: MockAppVersionProvider()
        )

        #expect(!subject.isUpdateRequired)
    }

    @Test
    func isUpdateRecommended_lowerCurrentVersion_returnsTrue() {
        let currentVersion = "0.1.0"
        let config = Config.arrange(
            recommendedVersion: "1.0.0"
        )
        let mockVersionProvider = MockAppVersionProvider()
        mockVersionProvider.versionNumber = currentVersion
        let subject = AppLaunchResponse(
            configResult: .success(.arrange(config: config)),
            topicResult: .success([]),
            notificationConsentResult: .aligned,
            remoteConfigFetchResult: .success,
            appVersionProvider: mockVersionProvider
        )

        #expect(subject.isUpdateRecommended)
    }

    @Test
    func isUpdateRecommended_higherCurrentVersion_returnsFalse() {
        let currentVersion = "1.0.0"
        let config = Config.arrange(
            recommendedVersion: "0.1.0"
        )
        let mockVersionProvider = MockAppVersionProvider()
        mockVersionProvider.versionNumber = currentVersion
        let subject = AppLaunchResponse(
            configResult: .success(.arrange(config: config)),
            topicResult: .success([]),
            notificationConsentResult: .aligned,
            remoteConfigFetchResult: .success,
            appVersionProvider: mockVersionProvider
        )

        #expect(!subject.isUpdateRecommended)
    }

    @Test
    func isUpdateRecommended_sameCurrentVersion_returnsFalse() {
        let currentVersion = "1.0.0"
        let config = Config.arrange(
            recommendedVersion: "1.0.0"
        )
        let mockVersionProvider = MockAppVersionProvider()
        mockVersionProvider.versionNumber = currentVersion
        let subject = AppLaunchResponse(
            configResult: .success(.arrange(config: config)),
            topicResult: .success([]),
            notificationConsentResult: .aligned,
            remoteConfigFetchResult: .success,
            appVersionProvider: mockVersionProvider
        )

        #expect(!subject.isUpdateRecommended)
    }

    @Test
    func isUpdateRecommended_error_returnsFalse() {
        let subject = AppLaunchResponse(
            configResult: .failure(.remoteJson),
            topicResult: .failure(.apiUnavailable),
            notificationConsentResult: .aligned,
            remoteConfigFetchResult: .success,
            appVersionProvider: MockAppVersionProvider()
        )

        #expect(!subject.isUpdateRecommended)
    }
}
