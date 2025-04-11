import Foundation
import Authentication

@testable import govuk_ios

class MockAuthenticationServiceClient: AuthenticationServiceClientInterface {
    var _stubbedResult: AuthenticationResult = .failure(.generic)
    func performAuthenticationFlow() -> AuthenticationResult {
        _stubbedResult
    }
}
