import Foundation
import UIKit
import Authentication

@testable import govuk_ios

class MockAuthenticationService: AuthenticationServiceInterface {
    var refreshToken: String?
    var idToken: String?
    var accessToken: String?
    var shouldReauthenticate: Bool = true

    var _stubbedAuthenticationResult: AuthenticationResult = .failure(.generic)
    func authenticate(window: UIWindow) async -> govuk_ios.AuthenticationResult {
        _stubbedAuthenticationResult
    }

    var _encryptRefreshTokenCallSuccess = false
    func encryptRefreshToken() {
        _encryptRefreshTokenCallSuccess = true
    }

    var _decryptRefreshTokenCallSuccess = false
    func decryptRefreshToken() {
        _decryptRefreshTokenCallSuccess = true
    }

    var _stubbedTokenRefreshRequest = TokenRefreshResult.failure(.decryptRefreshTokenError)
    func tokenRefreshRequest() async -> TokenRefreshResult {
        _stubbedTokenRefreshRequest
    }
}
