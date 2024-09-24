import Foundation

class MockAppConfigServiceClient: AppConfigServiceClientInterface {
    var _receivedAppConfigCompletion: ((Result<AppConfig, AppConfigError>) -> Void)?

    func fetchAppConfig(completion: @escaping (Result<AppConfig, AppConfigError>) -> Void) {
        _receivedAppConfigCompletion = completion
    }
}
