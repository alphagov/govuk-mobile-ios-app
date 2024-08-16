import Foundation

struct LocalFeatureFlagProvider: FeatureFlagProvider {
    private enum ConfigStrings: String {
        case jsonContainerName = "featureFlags"
        case configurationName = "FeatureFlags"
        case configurationType = "json"
    }
    private let pasingService: ParsingServiceInterface
    init(pasingService: ParsingServiceInterface) {
        self.pasingService = pasingService
    }

   func fetchFeatureToggles(_ completion: @escaping FeatureToggleCallback) {
        let configuration = loadConfiguration() ?? []
       completion(configuration)
    }
    func loadConfiguration() -> [FeatureFlag]? {
        guard let configurationURL = bundledConfigurationURL(),
              let data = try? Data(contentsOf: configurationURL) else {
            return nil
        }
        return parseConfiguration(data: data)
    }
     func parseConfiguration(data: Data) -> ParsingServiceResult? {
         return pasingService.parse(
            data,
            containerName: ConfigStrings.jsonContainerName.rawValue)
    }
    func bundledConfigurationURL() -> URL? {
        return Bundle.main.url(
            forResource: ConfigStrings.configurationName.rawValue,
            withExtension: ConfigStrings.configurationType.rawValue)
    }
}
