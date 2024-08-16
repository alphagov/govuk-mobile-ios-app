import Foundation

public final class FeatureFlagService {
    private init() { }
    static let shared = FeatureFlagService()
    private var featureFlags: [FeatureFlag] = []

    func fetchFeatureFlags(
        localFeatureFlagProvider: FeatureFlagProvider) {
            localFeatureFlagProvider.fetchFeatureToggles { [weak self] flags in
                guard let self = self else { return }
                self.featureFlags = flags
            }
            func isEnabled(_ feature: Feature) -> Bool {
                let feature = featureFlags.first(where: { $0.feature == feature })
                return feature?.enabled ?? false
            }
            func fetchLocalFeatureToggles(_ localFeatureFlagProvider: FeatureFlagProvider) {
                localFeatureFlagProvider.fetchFeatureToggles { [weak self] featureToggles in
                    if let self = self {
                        self.featureFlags = featureToggles
                    }
                }
            }
        }
}
