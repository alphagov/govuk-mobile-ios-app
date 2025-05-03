import Foundation
import UIKit
import Testing
import Authentication

@testable import govuk_ios

@Suite
struct AuthenticationServiceTests {
    @Test
    func authenticate_success_setsTokens() async {
        let mockUserDefaults = MockUserDefaults()
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            secureStoreService: mockSecureStoreService,
            userDefaults: mockUserDefaults
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
        mockAuthClient._stubbedAuthenticationResult = AuthenticationResult.success(tokenResponse)

        let result = await sut.authenticate(window: UIApplication.shared.window!)

        await confirmation() { confirmation in
            if case .success(_) = result {
                #expect(sut.refreshToken == expectedRefreshToken)
                #expect(sut.idToken == expectedIdToken)
                #expect(sut.accessToken == expectedAccessToken)
                confirmation()
            }
        }
    }

    @Test
    func authenticate_serviceClientError_returnsFailure() async {
        let mockUserDefaults = MockUserDefaults()
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        mockAuthClient._stubbedAuthenticationResult = .failure(.loginFlow(.clientError))
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            secureStoreService: mockSecureStoreService,
            userDefaults: mockUserDefaults
        )

        await confirmation() { confirmation in
            let result = await sut.authenticate(window: UIApplication.shared.window!)
            if case .failure(let error) = result {
                #expect(error == .loginFlow(.clientError))
                confirmation()
            }
        }
    }

    @Test
    func encryptRefreshToken_success_encryptsToken() async {
        let mockUserDefaults = MockUserDefaults()
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            secureStoreService: mockSecureStoreService,
            userDefaults: mockUserDefaults
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
        mockAuthClient._stubbedAuthenticationResult = .success(tokenResponse)
        _ = await sut.authenticate(window: UIApplication.shared.window!)
        sut.encryptRefreshToken()

        #expect(mockSecureStoreService._savedItems["refreshToken"] == expectedRefreshToken)
    }

    @Test
    func encryptRefreshToken_blankRefreshTokenFailure_doesntEncrypt() async {
        let mockUserDefaults = MockUserDefaults()
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            secureStoreService: mockSecureStoreService,
            userDefaults: mockUserDefaults
        )
        sut.encryptRefreshToken()

        #expect(mockSecureStoreService._savedItems["refreshToken"] == nil)
    }

    @Test
    func encryptRefreshToken_failedEncrypt_doesntEncrypt() async {
        let mockUserDefaults = MockUserDefaults()
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        mockSecureStoreService._stubbedSaveItemResult = .failure(TestSecureStoreError.failedEncrypt)
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            secureStoreService: mockSecureStoreService,
            userDefaults: mockUserDefaults
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
        mockAuthClient._stubbedAuthenticationResult = .success(tokenResponse)
        _ = await sut.authenticate(window: UIApplication.shared.window!)
        sut.encryptRefreshToken()

        #expect(mockSecureStoreService._savedItems["refreshToken"] == nil)
    }

    @Test
    func tokenRefreshRequest_successful_returnsSuccess() async {
        let mockUserDefaults = MockUserDefaults()
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        let idToken = UUID().uuidString
        let accessToken = UUID().uuidString
        let refreshToken = UUID().uuidString
        let tokenResponse = TokenRefreshResponse(
            accessToken: accessToken,
            idToken: idToken
        )
        mockAuthClient._stubbedTokenRefreshResult = .success(tokenResponse)
        mockSecureStoreService._stubbedReadItemResult = .success(refreshToken)
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            secureStoreService: mockSecureStoreService,
            userDefaults: mockUserDefaults
        )
        let tokenRefreshResult = await sut.tokenRefreshRequest()

        await confirmation() { confirmation in
            if case .success = tokenRefreshResult {
                #expect(sut.refreshToken == refreshToken)
                #expect(sut.accessToken == accessToken)
                #expect(sut.idToken == idToken)
                confirmation()
            }
        }
    }

    @Test
    func tokenRefreshRequest_decryptRefreshTokenError_returnsFailure() async {
        let mockUserDefaults = MockUserDefaults()
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        let idToken = UUID().uuidString
        let accessToken = UUID().uuidString
        let tokenResponse = TokenRefreshResponse(
            accessToken: accessToken,
            idToken: idToken
        )
        mockAuthClient._stubbedTokenRefreshResult = .success(tokenResponse)
        mockSecureStoreService._stubbedReadItemResult = .failure(NSError())
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            secureStoreService: mockSecureStoreService,
            userDefaults: mockUserDefaults
        )
        let tokenRefreshResult = await sut.tokenRefreshRequest()

        await confirmation() { confirmation in
            if case .failure(.decryptRefreshTokenError) = tokenRefreshResult {
                #expect(sut.refreshToken == nil)
                #expect(sut.accessToken == nil)
                #expect(sut.idToken == nil)
                confirmation()
            }
        }
    }

    @Test
    func tokenRefreshRequest_tokenResponseError_returnsFailure() async {
        let mockUserDefaults = MockUserDefaults()
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        let idToken = UUID().uuidString
        let accessToken = UUID().uuidString
        let tokenResponse = TokenRefreshResponse(
            accessToken: accessToken,
            idToken: idToken
        )
        mockAuthClient._stubbedTokenRefreshResult = .failure(.tokenResponseError)
        mockSecureStoreService._stubbedReadItemResult = .success(UUID().uuidString)
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            secureStoreService: mockSecureStoreService,
            userDefaults: mockUserDefaults
        )
        let tokenRefreshResult = await sut.tokenRefreshRequest()

        await confirmation() { confirmation in
            if case .failure(.tokenResponseError) = tokenRefreshResult {
                #expect(sut.refreshToken == nil)
                #expect(sut.accessToken == nil)
                #expect(sut.idToken == nil)
                confirmation()
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
