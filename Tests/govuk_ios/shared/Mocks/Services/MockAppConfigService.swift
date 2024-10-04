import Foundation

@testable import govuk_ios

class MockAppConfigService: AppConfigServiceInterface {
    var isAppAvailable: Bool = false

    var isAppForcedUpdate: Bool = false

    var features: [Feature] = [.onboarding, .search, .topics]
    
    func isFeatureEnabled(key: Feature) -> Bool {
        features.contains(key)
    }
}
