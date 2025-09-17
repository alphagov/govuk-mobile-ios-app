import Foundation

@testable import govuk_ios

class MockAppConfigService: AppConfigServiceInterface {
    var _stubbedChatPollIntervalSeconds: TimeInterval = 3.0
    var chatPollIntervalSeconds: TimeInterval {
        _stubbedChatPollIntervalSeconds
    }

    var isAppAvailable: Bool = false

    var isAppForcedUpdate: Bool = false

    var isAppRecommendUpdate: Bool = false

    var features: [Feature] = [.onboarding, .search, .topics, .recentActivity]

    var _stubbedAlertBanner: AlertBanner?
    var alertBanner: AlertBanner? {
        _stubbedAlertBanner
    }

    var _stubbedChatBanner: ChatBanner?
    var chatBanner: ChatBanner? {
        _stubbedChatBanner
    }

    var _stubbedChatBannerLink: ChatBanner.Link = .init(
        title: "test",
        url: URL(string: "https://test.com")!
    )
    var userChatBannerLink: ChatBanner.Link {
        _stubbedChatBannerLink
    }

    var _stubbedUserFeedbackBanner: UserFeedbackBanner?
    var userFeedbackBanner: UserFeedbackBanner? {
        _stubbedUserFeedbackBanner
    }

    var _stubbedUserFeedbackBannerLink: UserFeedbackBanner.Link = .init(
        title: "test",
        url: URL(string: "https://test.com")!
    )
    var userFeedbackBannerLink: UserFeedbackBanner.Link {
        _stubbedUserFeedbackBannerLink
    }

    var _stubbedChatUrls: ChatURLs?
    var chatUrls: ChatURLs? {
        _stubbedChatUrls
    }

    var _receivedFetchAppConfigCompletion: FetchAppConfigCompletion?
    var _stubbedFetchAppConfigResult: FetchAppConfigResult?
    func fetchAppConfig(completion: @escaping FetchAppConfigCompletion) {
        _receivedFetchAppConfigCompletion = completion
        if let result = _stubbedFetchAppConfigResult {
            completion(result)
        }
    }

    func isFeatureEnabled(key: Feature) -> Bool {
        features.contains(key)
    }
}
