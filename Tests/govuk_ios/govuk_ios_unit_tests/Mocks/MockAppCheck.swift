import Foundation

import Firebase
import FirebaseAppCheck

@testable import govuk_ios

class MockAppCheck: AppCheckInterface {
    var _stubbedToken: AppCheckToken?
    var _stubbedTokenError: AppAttestError?
    func token(forcingRefresh: Bool) async throws -> AppCheckToken {
        if let error = _stubbedTokenError {
            throw error
        }
        if let token = _stubbedToken {
            return token
        } else {
            fatalError("Error in test setup: either token or error must be stubbed")
        }
    }
}
