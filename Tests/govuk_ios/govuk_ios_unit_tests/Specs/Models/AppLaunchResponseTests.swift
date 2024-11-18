import Foundation
import Testing

@testable import govuk_ios

@Suite
struct AppLaunchResponseTests {
    @Test
    func isAppAvailable_invalidSignature_returnsTrue() async {
        let subject = AppLaunchResponse(
            configResult: .failure(.invalidSignature),
            topicResult: .success([]),
            appVersionProvider: MockAppVersionProvider()
        )

        #expect(!subject.isAppAvailable)
    }

    @Test
    func isAppAvailable_unavailable_returnsTrue() async {
        let subject = AppLaunchResponse(
            configResult: .success(.arrange(config: .arrange(available: false))),
            topicResult: .success([]),
            appVersionProvider: MockAppVersionProvider()
        )

        #expect(!subject.isAppAvailable)
    }

    @Test
    func isUpdateRequired_lowerCurrentVersion_returnsTrue() async {
        let currentVersion = "0.0.1"
        let config = Config.arrange(
            minimumVersion: "1.0.0"
        )
        let mockVersionProvider = MockAppVersionProvider()
        mockVersionProvider.versionNumber = currentVersion
        let subject = AppLaunchResponse(
            configResult: .success(.arrange(config: config)),
            topicResult: .success([]),
            appVersionProvider: mockVersionProvider
        )

        #expect(subject.isUpdateRequired)
    }

    @Test
    func isUpdateRequired_sameCurrentVersion_returnsFalse() async {
        let currentVersion = "1.0.0"
        let config = Config.arrange(
            minimumVersion: "1.0.0"
        )
        let mockVersionProvider = MockAppVersionProvider()
        mockVersionProvider.versionNumber = currentVersion
        let subject = AppLaunchResponse(
            configResult: .success(.arrange(config: config)),
            topicResult: .success([]),
            appVersionProvider: mockVersionProvider
        )

        #expect(!subject.isUpdateRequired)
    }

    @Test
    func isUpdateRequired_higherCurrentVersion_returnsFalse() async {
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
            appVersionProvider: mockVersionProvider
        )

        #expect(!subject.isUpdateRequired)
    }

    @Test
    func isUpdateRequired_invalidSignature_returnsFalse() async {
        let subject = AppLaunchResponse(
            configResult: .failure(.invalidSignature),
            topicResult: .success([]),
            appVersionProvider: MockAppVersionProvider()
        )

        #expect(subject.isUpdateRequired)
    }

    @Test
    func isUpdateRequired_error_returnsFalse() async {
        let subject = AppLaunchResponse(
            configResult: .failure(.remoteJson),
            topicResult: .failure(.apiUnavailable),
            appVersionProvider: MockAppVersionProvider()
        )

        #expect(!subject.isUpdateRequired)
    }

    @Test
    func isUpdateRecommended_lowerCurrentVersion_returnsTrue() async {
        let currentVersion = "0.1.0"
        let config = Config.arrange(
            recommendedVersion: "1.0.0"
        )
        let mockVersionProvider = MockAppVersionProvider()
        mockVersionProvider.versionNumber = currentVersion
        let subject = AppLaunchResponse(
            configResult: .success(.arrange(config: config)),
            topicResult: .success([]),
            appVersionProvider: mockVersionProvider
        )

        #expect(subject.isUpdateRecommended)
    }

    @Test
    func isUpdateRecommended_higherCurrentVersion_returnsFalse() async {
        let currentVersion = "1.0.0"
        let config = Config.arrange(
            recommendedVersion: "0.1.0"
        )
        let mockVersionProvider = MockAppVersionProvider()
        mockVersionProvider.versionNumber = currentVersion
        let subject = AppLaunchResponse(
            configResult: .success(.arrange(config: config)),
            topicResult: .success([]),
            appVersionProvider: mockVersionProvider
        )

        #expect(!subject.isUpdateRecommended)
    }

    @Test
    func isUpdateRecommended_sameCurrentVersion_returnsFalse() async {
        let currentVersion = "1.0.0"
        let config = Config.arrange(
            recommendedVersion: "1.0.0"
        )
        let mockVersionProvider = MockAppVersionProvider()
        mockVersionProvider.versionNumber = currentVersion
        let subject = AppLaunchResponse(
            configResult: .success(.arrange(config: config)),
            topicResult: .success([]),
            appVersionProvider: mockVersionProvider
        )

        #expect(!subject.isUpdateRecommended)
    }

    @Test
    func isUpdateRecommended_error_returnsFalse() async {
        let subject = AppLaunchResponse(
            configResult: .failure(.remoteJson),
            topicResult: .failure(.apiUnavailable),
            appVersionProvider: MockAppVersionProvider()
        )

        #expect(!subject.isUpdateRecommended)
    }
}
