import Foundation

@testable import govuk_ios

class MockAppConfigServiceClient: AppConfigServiceClientInterface {
    var _receivedFetchAppConfigCompletion: FetchAppConfigCompletion?
    func fetchAppConfig(completion: @escaping FetchAppConfigCompletion) {
        _receivedFetchAppConfigCompletion = completion
    }
}
