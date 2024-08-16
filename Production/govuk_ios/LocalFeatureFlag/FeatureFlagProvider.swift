import Foundation

typealias FeatureToggleCallback = ([FeatureFlag]) -> Void
protocol FeatureFlagProvider {
   func fetchFeatureToggles(_ completion: @escaping FeatureToggleCallback)
}
