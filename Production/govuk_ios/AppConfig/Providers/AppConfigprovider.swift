import Foundation

class AppConfigProvider: AppConfigProviderInterface {
    func fetchAppConfig(filename: String,
                        completion: @escaping(Result<AppConfig, AppConfigError>) -> Void) {
                                let config = loadJSON(filename: filename, bundle: .main)
                                completion(config)
                            }

    private func loadJSON(filename: String,
                          bundle: Bundle) -> Result<AppConfig, AppConfigError> {
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
