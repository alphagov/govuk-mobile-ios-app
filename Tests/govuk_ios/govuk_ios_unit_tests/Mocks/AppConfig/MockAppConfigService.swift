import Foundation

class MockAppConfigService: AppConfigServiceInterface {
    var features: [Feature] = [.search]
    func isFeatureEnabled(key: Feature) -> Bool {
        features.contains(key)
    }
}
