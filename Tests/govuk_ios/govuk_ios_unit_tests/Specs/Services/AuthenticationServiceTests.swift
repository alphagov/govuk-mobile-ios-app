import Foundation
import UIKit
import Testing
import Authentication

@testable import govuk_ios

@Suite
@MainActor
struct AuthenticationServiceTests {
    @Test
    func authenticate_success_setsTokens() async {
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockAuthTokenSet = MockAuthenticationTokenSet()
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            authenticationTokenSet: mockAuthTokenSet
        )
        let expectedAccessToken = "access_token_value"
        let expectedRefreshToken = "refresh_token_value"
        let expectedIdToken = "id_token"
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

        let tokenResponse = createTokenResponse(jsonData)
        mockAuthClient._stubbedResult = .success(tokenResponse)

        let result = await sut.authenticate(window: UIApplication.shared.window!)

        await confirmation("Auth request success") { authRequestComplete in
            if case .success(_) = result {
                #expect(mockAuthTokenSet.tokensSet?.0 == expectedRefreshToken)
                #expect(mockAuthTokenSet.tokensSet?.1 == expectedIdToken)
                #expect(mockAuthTokenSet.tokensSet?.2 == expectedAccessToken)
                authRequestComplete()
            }
        }
    }

    @Test
    func authenticate_missingAccessToken_returnsFailure() async {
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockAuthTokenSet = MockAuthenticationTokenSet()
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            authenticationTokenSet: mockAuthTokenSet
        )
        let jsonData = """
        {
            "accessToken": "",
            "refreshToken": "refresh_token_value",
            "idToken": "id_token",
            "tokenType": "id_token",
            "expiryDate": "2099-01-01T00:00:00Z"
        }
        """.data(using: .utf8)!
        let tokenResponse = createTokenResponse(jsonData)
        mockAuthClient._stubbedResult = .success(tokenResponse)

        await confirmation("Auth request failure") { authRequestComplete in
            let result = await sut.authenticate(window: UIApplication.shared.window!)
            if case .failure(let error) = result {
                #expect(error == .missingAccessToken)
                authRequestComplete()
            }
        }
    }

    @Test
    func authenticate_missingRefreshToken_returnsFailure() async {
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockAuthTokenSet = MockAuthenticationTokenSet()
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            authenticationTokenSet: mockAuthTokenSet
        )
        let jsonData = """
        {
            "accessToken": "acces_token",
            "idToken": "id_token",
            "tokenType": "id_token",
            "expiryDate": "2099-01-01T00:00:00Z"
        }
        """.data(using: .utf8)!
        let tokenResponse = createTokenResponse(jsonData)
        mockAuthClient._stubbedResult = .success(tokenResponse)

        await confirmation("Auth request failure") { authRequestComplete in
            let result = await sut.authenticate(window: UIApplication.shared.window!)
            if case .failure(let error) = result {
                #expect(error == .missingRefreshToken)
                authRequestComplete()
            }
        }
    }

    @Test
    func authenticate_missingIDToken_returnsFailure() async {
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockAuthTokenSet = MockAuthenticationTokenSet()
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            authenticationTokenSet: mockAuthTokenSet
        )
        let jsonData = """
        {
            "accessToken": "acces_token",
            "refreshToken": "refresh_token_value",
            "tokenType": "id_token",
            "expiryDate": "2099-01-01T00:00:00Z"
        }
        """.data(using: .utf8)!
        let tokenResponse = createTokenResponse(jsonData)
        mockAuthClient._stubbedResult = .success(tokenResponse)

        await confirmation("Auth request failure") { authRequestComplete in
            let result = await sut.authenticate(window: UIApplication.shared.window!)
            if case .failure(let error) = result {
                #expect(error == .missingIDToken)
                authRequestComplete()
            }
        }
    }

    @Test
    func authenticate_serviceClientError_returnsFailure() async {
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockAuthTokenSet = MockAuthenticationTokenSet()
        mockAuthClient._stubbedResult = .failure(.loginFlow(.clientError))
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            authenticationTokenSet: mockAuthTokenSet
        )

        await confirmation("Auth request failure") { authRequestComplete in
            let result = await sut.authenticate(window: UIApplication.shared.window!)
            if case .failure(let error) = result {
                #expect(error == .loginFlow(.clientError))
                authRequestComplete()
            }
        }
    }

    private func createTokenResponse(_ jsonData: Data) -> TokenResponse {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let tokenResponse = try? decoder.decode(TokenResponse.self, from: jsonData)
        return tokenResponse!
    }
}
