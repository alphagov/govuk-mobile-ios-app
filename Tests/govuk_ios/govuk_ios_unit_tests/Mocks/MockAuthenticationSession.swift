import Foundation
import UIKit
import Authentication

@testable import govuk_ios

@MainActor
class MockAuthenticationSessionWrapper: AppAuthSessionWrapperInterface {
    var _mockAuthenticationSession = MockAuthenticationSession()
    func session(window: UIWindow) -> LoginSession {
        _mockAuthenticationSession
    }
}

class MockAuthenticationSession: LoginSession {
    var _shouldReturnError: Bool = false
    var _tokenResponse: TokenResponse = tokenResponse
    func performLoginFlow(configuration: LoginSessionConfiguration) async throws -> TokenResponse {
        if _shouldReturnError {
            throw LoginError.userCancelled
        }
        
        return MockAuthenticationSession.tokenResponse
    }

    func finalise(redirectURL url: URL) throws {}

    private static var tokenResponse: TokenResponse {
        let expectedAccessToken = "access_token_value"
        let expectedRefreshToken = "refresh_token_value"
        let expectedIdToken = "id_token_value"
        let expectedExpiryDate = "2099-01-01T00:00:00Z"
        let jsonData = """
        {
            "accessToken": "\(expectedAccessToken)",
            "refreshToken": "\(expectedRefreshToken)",
            "idToken": "\(expectedIdToken)",
            "tokenType": "id_token",
            "expiryDate": "\(expectedExpiryDate)"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let tokenResponse = try? decoder.decode(TokenResponse.self, from: jsonData)
        return tokenResponse!
    }
}
