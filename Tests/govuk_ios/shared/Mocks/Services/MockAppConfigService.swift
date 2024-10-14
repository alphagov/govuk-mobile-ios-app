import Foundation

@testable import govuk_ios

class MockAppConfigService: AppConfigServiceInterface {
    var isAppAvailable: Bool = false

    var isAppForcedUpdate: Bool = false

    var isAppRecommendUpdate: Bool = false

    var features: [Feature] = [.onboarding, .search, .topics]

    var _fetchAppConfigCompletion: (() -> Void)?

    func fetchAppConfig(completion: @escaping () -> Void) {
        _fetchAppConfigCompletion = completion
    }

    func isFeatureEnabled(key: Feature) -> Bool {
        features.contains(key)
    }
}
