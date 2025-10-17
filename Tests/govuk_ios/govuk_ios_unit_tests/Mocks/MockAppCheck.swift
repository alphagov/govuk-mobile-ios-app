import Foundation

import Firebase
import FirebaseAppCheck

@testable import govuk_ios

class MockAppCheck: AppCheckInterface {
    var _stubbedAppCheckToken: AppCheckToken?
    func token(forcingRefresh: Bool) async throws -> AppCheckToken {
        guard let token = _stubbedAppCheckToken else {
            throw AppCheckError.tokenRefreshFailed
        }
        return token
    }

    enum AppCheckError: Error {
        case tokenRefreshFailed
    }
}
