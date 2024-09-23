import Foundation

typealias FetchAppConfigResult = (Result<AppConfig, AppConfigError>) -> Void

protocol AppConfigServiceClientInterface {
    func fetchAppConfig(completion: @escaping FetchAppConfigResult)
}
