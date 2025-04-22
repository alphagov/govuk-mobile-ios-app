import Foundation
import UIKit
import Authentication

@testable import govuk_ios

class MockAuthenticationService: AuthenticationServiceInterface {
    var _stubbedResult: AuthenticationResult = .failure(.generic)
    func authenticate(window: UIWindow) async -> govuk_ios.AuthenticationResult {
        _stubbedResult
    }

    var _encryptRefreshTokenCallSuccess = false
    var _encryptRefreshTokenError: Error?
    func encryptRefreshToken() throws {
        if let error = _encryptRefreshTokenError {
            throw error
        }
        _encryptRefreshTokenCallSuccess = true
    }

    var _decryptRefreshTokenCallSuccess = false
    var _decryptRefreshTokenError: Error?
    func decryptRefreshToken() throws {
        if let error = _decryptRefreshTokenError {
            throw error
        }
        _decryptRefreshTokenCallSuccess = true
    }
}
