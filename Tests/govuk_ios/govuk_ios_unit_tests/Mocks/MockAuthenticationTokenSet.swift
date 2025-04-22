import Foundation

@testable import govuk_ios

struct MockAuthenticationTokenSet: AuthenticationTokenSetInterface {
    var refreshToken: String? = "refresh_token"
    var idToken: String? = "id_token"
    var accessToken: String? = "access_token"
}
