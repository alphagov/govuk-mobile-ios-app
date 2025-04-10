import Foundation
import Authentication

@testable import govuk_ios

class MockAuthenticationService: AuthenticationServiceInterface {
    var _stubbedError: AuthenticationError? = nil
    func authenticate(completion: @escaping (Result<Void, AuthenticationError>) -> Void) async {
        if let error = _stubbedError {
            completion(.failure(error))
        } else {
            completion(.success(()))
        }
    }
}
