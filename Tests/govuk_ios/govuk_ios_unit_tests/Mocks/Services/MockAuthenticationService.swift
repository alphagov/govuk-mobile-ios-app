import Foundation
import UIKit
import Authentication

@testable import govuk_ios

class MockAuthenticationService: AuthenticationServiceInterface {
    var _storedRefreshToken = true
    var secureStoreRefreshToken: Bool {
        _storedRefreshToken
    }

    var _stubbedUserEmail: String?
    var userEmail: String? {
        _stubbedUserEmail
    }

    var _stubbedIsSignedIn: Bool = false
    var isSignedIn: Bool {
        _stubbedIsSignedIn
    }

    var _stubbedIsReauth: Bool = false
    var isReauth: Bool {
        _stubbedIsReauth
    }

    func signOut() {
        _stubbedIsSignedIn = false
    }

    var refreshToken: String?
    var idToken: String?
    var accessToken: String?

    var _stubbedAuthenticationResult: AuthenticationServiceResult = .failure(.loginFlow(.clientError))
    func authenticate(window: UIWindow) async -> govuk_ios.AuthenticationServiceResult {
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
