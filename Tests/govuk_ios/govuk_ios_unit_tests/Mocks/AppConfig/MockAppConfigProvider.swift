import Foundation

class MockAppConfigProvider: AppConfigProviderInterface {

    var _receivedLocalAppConfigCompletion: ((Result<AppConfig, AppConfigError>) -> Void)?

    func fetchLocalAppConfig(filename: String,
                        completion: @escaping (Result<AppConfig, AppConfigError>) -> Void) {
        _receivedLocalAppConfigCompletion = completion
    }

    var _receivedRemoteAppConfigCompletion: ((Result<AppConfig, AppConfigError>) -> Void)?

    func fetchRemoteAppConfig(completion: @escaping (Result<AppConfig, AppConfigError>) -> Void) {
        _receivedRemoteAppConfigCompletion = completion
    }
}
