import Foundation

import Firebase
import FirebaseAppCheck

@testable import govuk_ios

class MockAppAttestService: NSObject,
                            AppAttestServiceInterface {
    var _stubbedAppCheckToken: AppCheckToken?
    var _stubbedTokenFetchError: TestError = .fakeNetwork
    func token() async throws -> AppCheckToken {
        if let token = _stubbedAppCheckToken {
            return token
        }
        throw _stubbedTokenFetchError
    }
}
