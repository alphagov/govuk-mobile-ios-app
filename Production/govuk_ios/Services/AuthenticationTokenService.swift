import Foundation

protocol AuthenticationTokenServiceInterface {
    func setTokens(refreshToken: String, idToken: String, accessToken: String)
}

class AuthenticationTokenService: AuthenticationTokenServiceInterface {
    var refreshToken: String?
    var idToken: String?
    var accessToken: String?

    func setTokens(refreshToken: String, idToken: String, accessToken: String) {
        self.refreshToken = refreshToken
        self.idToken = idToken
        self.accessToken = accessToken
    }
}
