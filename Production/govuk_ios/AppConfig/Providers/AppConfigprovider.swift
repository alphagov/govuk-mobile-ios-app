import Foundation

class AppConfigProvider: AppConfigProviderInterface {
    func fetchAppConfig(filename: String,
                        completionHandler: @escaping (
                            Result<AppConfig, AppConfigServiceError>) -> Void) {
                                let config = loadJSON(filename: filename, bundle: .main)
                                completionHandler(config)
                            }

    private func loadJSON(filename: String,
                          bundle: Bundle) -> Result<AppConfig, AppConfigServiceError> {
        guard let resourceURL = bundle.url(
            forResource: filename,
            withExtension: "json") else {
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
