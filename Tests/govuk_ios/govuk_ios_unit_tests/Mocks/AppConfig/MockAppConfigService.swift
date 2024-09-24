import Foundation

class MockAppConfigService: AppConfigServiceInterface {
    var features: [Feature] = [.onboarding, .search]
    func isFeatureEnabled(key: Feature) -> Bool {
        features.contains(key)
    }
}
