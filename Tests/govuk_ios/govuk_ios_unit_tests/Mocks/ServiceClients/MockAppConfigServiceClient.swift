import Foundation

@testable import govuk_ios

class MockAppConfigServiceClient: AppConfigServiceClientInterface {
    var _receivedFetchAppConfigCompletion: ((Result<AppConfig, AppConfigError>) -> Void)?
    func fetchAppConfig(completion: @escaping (Result<AppConfig, AppConfigError>) -> Void) {
        _receivedFetchAppConfigCompletion = completion
    }
}
