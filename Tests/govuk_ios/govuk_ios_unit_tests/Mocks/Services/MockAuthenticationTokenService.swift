import Foundation

@testable import govuk_ios

class MockAuthenticationTokenService: AuthenticationTokenServiceInterface {
    var tokensSet: (String?, String?, String?)? = nil
    func setTokens(refreshToken: String, idToken: String, accessToken: String) {
        tokensSet = (refreshToken, idToken, accessToken)
    }
}
