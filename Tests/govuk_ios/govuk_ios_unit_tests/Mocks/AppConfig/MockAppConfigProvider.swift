import Foundation

class MockAppConfigProvider: AppConfigProviderInterface {

    var _receivedAppConfigCompletion:
    ((Result<AppConfig, AppConfigServiceError>) -> Void)?

    func fetchAppConfig(filename: String ,completionHandler: @escaping (Result<AppConfig, AppConfigServiceError>) -> Void) {
        _receivedAppConfigCompletion = completionHandler
    }
}
