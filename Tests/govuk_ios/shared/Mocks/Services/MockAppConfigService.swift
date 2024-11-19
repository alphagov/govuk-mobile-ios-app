import Foundation

@testable import govuk_ios

class MockAppConfigService: AppConfigServiceInterface {
    var isAppAvailable: Bool = false

    var isAppForcedUpdate: Bool = false

    var isAppRecommendUpdate: Bool = false

    var features: [Feature] = [.onboarding, .search, .topics, .recentActivity]

    var _receivedFetchAppConfigCompletion: FetchAppConfigCompletion?
    func fetchAppConfig(completion: @escaping FetchAppConfigCompletion) {
        _receivedFetchAppConfigCompletion = completion
    }

    func isFeatureEnabled(key: Feature) -> Bool {
        features.contains(key)
    }
}
