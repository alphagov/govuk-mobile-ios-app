import Foundation
import Authentication

@testable import govuk_ios

class MockAuthenticationServiceClient: AuthenticationServiceClientInterface {
    var _stubbedResult: Result<Authentication.TokenResponse, AuthenticationError> = .failure(.flowError)
    func performAuthenticationFlow(
        completion: @escaping (Result<Authentication.TokenResponse, AuthenticationError>) -> Void
    ) {
        completion(_stubbedResult)
    }
}
