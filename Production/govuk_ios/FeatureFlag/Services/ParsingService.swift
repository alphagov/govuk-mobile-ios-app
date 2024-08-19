import Foundation

struct ParsingService: ParsingServiceInterface {
    func loadJSON(bundle: Bundle,
                  filename: String,
                  fileType: String) -> Result<AppConfig, AppConfigServiceError> {
            guard let resourceURL = bundle.url(
                forResource: filename,
                withExtension: fileType) else {
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
