import Foundation
import UIKit
import Authentication

@testable import govuk_ios

class MockAuthenticationService: AuthenticationServiceInterface {

    var _storedRefreshToken = true
    var secureStoreRefreshTokenPresent: Bool {
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

    var _receivedSignOutReason: SignoutReason?
    func signOut(reason: SignoutReason) {
        _receivedSignOutReason = reason
        _stubbedIsSignedIn = false
    }

    var refreshToken: String?
    var idToken: String?
    var accessToken: String?
    var didSignOutAction: ((SignoutReason) -> Void)?

    var _stubbedAuthenticationResult: AuthenticationServiceResult = .failure(.loginFlow(.init(reason: .authorizationClientError)))
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
    var _tokenRefreshRequestCalled = false
    func tokenRefreshRequest() async -> TokenRefreshResult {
        _tokenRefreshRequestCalled = true
        return _stubbedTokenRefreshRequest
    }

    var _stubbedShouldAttemptTokenRefresh: Bool = true
    var shouldAttemptTokenRefresh: Bool {
        _stubbedShouldAttemptTokenRefresh
    }

    func clearRefreshToken() {
        refreshToken = nil
    }
}
