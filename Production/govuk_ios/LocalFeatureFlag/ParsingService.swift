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
           let featureToggles = jsonContainer[containerName],
           let featureTogglesData = try? JSONSerialization.data(withJSONObject: featureToggles) {
               toggleData = featureTogglesData
       }
       return try? JSONDecoder().decode([FeatureFlag].self, from: toggleData)
   }
}
