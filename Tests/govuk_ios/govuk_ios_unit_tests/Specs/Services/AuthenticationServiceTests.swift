import Foundation
import UIKit
import Testing
import Authentication

@testable import govuk_ios

@Suite
struct AuthenticationServiceTests {
    @Test
    func authenticate_success_setsTokens() async {
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        let tokenSet = AuthenticationTokenSet.shared
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            secureStoreService: mockSecureStoreService
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
                #expect(tokenSet.refreshToken == expectedRefreshToken)
                #expect(tokenSet.idToken == expectedIdToken)
                #expect(tokenSet.accessToken == expectedAccessToken)
                authRequestComplete()
            }
        }
    }

    @Test
    func authenticate_serviceClientError_returnsFailure() async {
        let mockAuthClient = MockAuthenticationServiceClient()
        mockAuthClient._stubbedResult = .failure(.loginFlow(.clientError))
        let mockSecureStoreService = MockSecureStoreService()
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            secureStoreService: mockSecureStoreService
        )

        await confirmation("Auth request failure") { authRequestComplete in
            let result = await sut.authenticate(window: UIApplication.shared.window!)
            if case .failure(let error) = result {
                #expect(error == .loginFlow(.clientError))
                authRequestComplete()
            }
        }
    }

    @Test
    func encryptRefreshToken_success_encryptsToken() async {
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            secureStoreService: mockSecureStoreService
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
        _ = await sut.authenticate(window: UIApplication.shared.window!)
        try! sut.encryptRefreshToken()

        #expect(mockSecureStoreService._savedItems["refreshToken"] == expectedRefreshToken)
    }

    @Test
    func encryptRefreshToken_blankRefreshTokenFailure_throwsError() async {
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            secureStoreService: mockSecureStoreService
        )

        await confirmation() { confirmation in
            do {
                try sut.encryptRefreshToken()
            } catch {
                switch error {
                case AuthenticationTokenError.blankRefreshToken:
                    confirmation()
                default:
                    Issue.record("Should throw blank refresh token error")
                }
            }
        }
    }

    @Test
    func encryptRefreshToken_failedEncrypt_throwsError() async {
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        mockSecureStoreService._stubbedSaveItemResult = .failure(TestSecureStoreError.failedEncrypt)
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            secureStoreService: mockSecureStoreService
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
        _ = await sut.authenticate(window: UIApplication.shared.window!)

        await confirmation() { confirmation in
            do {
                try sut.encryptRefreshToken()
            } catch {
                switch error {
                case TestSecureStoreError.failedEncrypt:
                    confirmation()
                default:
                    Issue.record("Should throw blank refresh token error")
                }
            }
        }
    }

    private func createTokenResponse(_ jsonData: Data) -> TokenResponse {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let tokenResponse = try? decoder.decode(TokenResponse.self, from: jsonData)
        return tokenResponse!
    }

    enum TestSecureStoreError: Error {
        case failedDecrypt, failedEncrypt
    }
}
