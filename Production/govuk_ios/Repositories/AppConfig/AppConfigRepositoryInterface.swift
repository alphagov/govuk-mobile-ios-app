import Foundation

protocol AppConfigRepositoryInterface {
    func fetchAppConfig(filename: String,
                        completion: @escaping (Result<AppConfig, AppConfigError>) -> Void)
}
