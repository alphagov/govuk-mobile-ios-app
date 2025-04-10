import Foundation

protocol AuthenticationTokenSetInterface {
    func setTokens(refreshToken: String, idToken: String, accessToken: String)
}

class AuthenticationTokenSet: AuthenticationTokenSetInterface {
    static let shared = AuthenticationTokenSet()

    var refreshToken: String?
    var idToken: String?
    var accessToken: String?

    private init() {}

    func setTokens(refreshToken: String, idToken: String, accessToken: String) {
        self.refreshToken = refreshToken
        self.idToken = idToken
        self.accessToken = accessToken
    }
}
