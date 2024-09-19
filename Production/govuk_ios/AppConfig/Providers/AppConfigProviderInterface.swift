import Foundation

protocol AppConfigProviderInterface {
    func fetchLocalAppConfig(filename: String,
                             completion: @escaping (Result<AppConfig, AppConfigError>) -> Void)

    func fetchRemoteAppConfig(completion: @escaping (Result<AppConfig, AppConfigError>) -> Void)
}
