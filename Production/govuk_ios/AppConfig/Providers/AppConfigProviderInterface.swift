import Foundation

protocol AppConfigProviderInterface {
    func fetchAppConfig(filename: String,
                        completion: @escaping (Result<AppConfig, AppConfigError>) -> Void)
}
