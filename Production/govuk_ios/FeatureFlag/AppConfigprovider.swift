import Foundation

struct AppConfigprovider: AppConfigProviderInterface {
    private let parsingService: ParsingServiceInterface
    private enum ConfigStrings: String {
        case filename = "RemoteConfigResponse"
        case fileType = "json"
    }

    init(pasingService: ParsingServiceInterface) {
        self.parsingService = pasingService
    }

    func fetchAppConfig(
        completionHandler: @escaping (Result<AppConfig, AppConfigServiceError>) -> Void) {
            let config = loadJSON(bundle: .main)
            completionHandler(config)
        }

    private func loadJSON(bundle: Bundle) -> Result<AppConfig, AppConfigServiceError> {
        guard let resourceURL = bundle.url(
            forResource: ConfigStrings.filename.rawValue,
            withExtension: ConfigStrings.fileType.rawValue) else {
            return .failure(.loadJsonError)
        }
        do {
            let data = try Data(contentsOf: resourceURL)
            let decodedObject = try
            JSONDecoder().decode(AppConfig.self, from: data)
            return .success(decodedObject)
        } catch {
            return .failure(.loadJsonError)
        }
    }
}
