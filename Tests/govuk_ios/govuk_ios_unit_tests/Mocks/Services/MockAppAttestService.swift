import Foundation
import FirebaseAppCheck

@testable import govuk_ios

class MockAppAttestService: NSObject, AppAttestServiceInterface {

    var _stubbedAppCheckToken: AppCheckToken?
    var _stubbedTokenFetchError: TestError = .fakeNetwork
    func token(forcingRefresh: Bool) async throws -> AppCheckToken {
        if let token = _stubbedAppCheckToken {
            return token
        }
        throw _stubbedTokenFetchError
    }

    var _configureCalled = false
    func configure() {
        _configureCalled = true
    }
}
