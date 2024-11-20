import Foundation

@testable import govuk_ios

class MockAppLaunchService: AppLaunchServiceInterface {
    var _receivedFetchCompletion: ((sending AppLaunchResponse) -> Void)?
    func fetch(completion: @escaping (sending AppLaunchResponse) -> Void) {
        _receivedFetchCompletion = completion
    }
}
