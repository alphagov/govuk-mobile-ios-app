import Foundation

typealias ParsingServiceResult = [FeatureFlag]
 protocol ParsingServiceInterface {
    func parse(_ data: Data, containerName: String) -> ParsingServiceResult?
}

struct ParsingService: ParsingServiceInterface {
   func parse(_ data: Data, containerName: String) -> ParsingServiceResult? {
       var toggleData = data
       if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
           let jsonContainer = json as? [String: Any],
           let featureFlags = jsonContainer[containerName],
           let featureFlagData = try? JSONSerialization.data(withJSONObject: featureFlags) {
               toggleData = featureFlagData
       }
       return try? JSONDecoder().decode([FeatureFlag].self, from: toggleData)
   }
}
