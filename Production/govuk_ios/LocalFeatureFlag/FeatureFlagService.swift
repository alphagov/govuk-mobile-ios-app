import Foundation

public final class FeatureFlagService {
    private init() { }
    static let shared = FeatureFlagService()
    private var featureFlags: [FeatureFlag] = []

    func fetchFeatureFlags(
        localFeatureFlagProvider: FeatureFlagProviderInterface) {
            localFeatureFlagProvider.fetchFeatureFlags { [weak self] flags in
                guard let self = self else { return }
                self.featureFlags = flags
            }
            func isEnabled(_ feature: Feature) -> Bool {
                let feature = featureFlags.first(where: { $0.feature == feature })
                return feature?.enabled ?? false
            }
            func fetchLocalFeatureToggles( localFeatureFlagProvider: FeatureFlagProviderInterface) {
                localFeatureFlagProvider.fetchFeatureFlags { [weak self] featureFlags in
                    if let self = self {
                        self.featureFlags = featureFlags
                    }
                }
            }
        }
}
