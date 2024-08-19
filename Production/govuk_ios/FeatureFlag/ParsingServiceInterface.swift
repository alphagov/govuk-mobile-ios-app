import Foundation

 protocol ParsingServiceInterface {
     func loadJSON(bundle: Bundle,
                   filename: String,
                   fileType: String) -> Result<AppConfig, AppConfigServiceError>
}
