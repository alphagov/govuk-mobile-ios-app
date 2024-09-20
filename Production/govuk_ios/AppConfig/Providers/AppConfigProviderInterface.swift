import Foundation

typealias FetchAppConfigResult = (Result<AppConfig, AppConfigError>) -> Void

protocol AppConfigProviderInterface {
    func fetchLocalAppConfig(filename: String,
                             completion: @escaping FetchAppConfigResult)

    func fetchRemoteAppConfig(completion: @escaping FetchAppConfigResult)
}
