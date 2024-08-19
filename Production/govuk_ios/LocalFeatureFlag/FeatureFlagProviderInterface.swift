import Foundation

typealias FeatureFlagCallback = ([FeatureFlag]) -> Void

protocol FeatureFlagProviderInterface {
   func fetchFeatureFlags(_ completion: @escaping FeatureFlagCallback)
}
