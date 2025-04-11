import Foundation
import Testing

@testable import govuk_ios

@Suite
class AuthenticationTokenSetTests {
    @Test
    func setTokens_SetsTokens() {
        let tokenSet = AuthenticationTokenSet.shared
        let expectedRefreshToken = "test_refresh_token"
        let expectedIdToken = "test_id_token"
        let expectedAccessToken = "test_access_token"

        tokenSet.setTokens(
            refreshToken: expectedRefreshToken,
            idToken: expectedIdToken,
            accessToken: expectedAccessToken
        )

        #expect(tokenSet.refreshToken == expectedRefreshToken)
        #expect(tokenSet.idToken == expectedIdToken)
        #expect(tokenSet.accessToken == expectedAccessToken)
    }
}
