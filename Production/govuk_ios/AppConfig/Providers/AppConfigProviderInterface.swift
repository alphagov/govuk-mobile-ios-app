import Foundation

protocol AppConfigProviderInterface {
 func fetchAppConfig(filename: String,
                     completionHandler:
                     @escaping (Result<AppConfig, AppConfigServiceError>) -> Void)
}
