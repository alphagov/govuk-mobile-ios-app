import Foundation

@testable import govuk_ios

class MockAuthenticationTokenService: AuthenticationTokenServiceInterface {
    var mockTokenSet = AuthenticationTokenSet.shared

    var _encryptRefreshTokenCallSuccess = false
    var _encryptRefreshTokenError: Error?
    func encryptRefreshToken() throws {
        if let error = _encryptRefreshTokenError {
            throw error
        }
        _encryptRefreshTokenCallSuccess = true
    }

    var _stubbedRefreshToken = UUID().uuidString
    var _decryptRefreshTokenError: Error?
    func decryptRefreshToken() throws {
        if let error = _decryptRefreshTokenError {
            throw error
        } else {
            mockTokenSet.refreshToken = _stubbedRefreshToken
        }
    }

    func deleteTokens() {
        mockTokenSet.refreshToken = nil
        mockTokenSet.idToken = nil
        mockTokenSet.accessToken = nil
    }
}
