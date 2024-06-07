import Foundation

@testable import govuk_ios

class MockDeeplinkService: DeeplinkServiceInterface {

    func handle(url: String?,
                completion: @escaping () -> Void) {
        completion()
    }

}
