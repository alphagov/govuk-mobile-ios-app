import Foundation

@testable import govuk_ios

class MockAppConfigRepository: AppConfigRepositoryInterface {
    var _receivedFetchAppConfigCompletion: ((Result<AppConfig, AppConfigError>) -> Void)?
    func fetchAppConfig(filename: String,
                        completion: @escaping (Result<AppConfig, AppConfigError>) -> Void) {
        _receivedFetchAppConfigCompletion = completion
    }
}
