import Foundation
import Authentication

@testable import govuk_ios

class MockAuthenticationService: AuthenticationServiceInterface {
    var _stubbedResult: AuthenticationResult = .failure(.generic)
    func authenticate() -> AuthenticationResult {
        _stubbedResult
    }
}
