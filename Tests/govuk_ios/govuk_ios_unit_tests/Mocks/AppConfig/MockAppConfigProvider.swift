import Foundation

class MockAppConfigProvider: AppConfigProviderInterface {

    var _receivedAppConfigCompletion: ((Result<AppConfig, AppConfigError>) -> Void)?

    func fetchAppConfig(filename: String,
                        completion: @escaping (Result<AppConfig, AppConfigError>) -> Void) {
        _receivedAppConfigCompletion = completion
    }
}
