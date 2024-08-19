import Foundation

protocol AppConfigProviderInterface {
   func fetchAppConfig(completionHandler:
                       @escaping (Result<AppConfig, AppConfigServiceError>) -> Void)
}
