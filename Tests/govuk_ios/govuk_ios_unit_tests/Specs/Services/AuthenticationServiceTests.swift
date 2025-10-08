import Foundation
import UIKit
import Testing
import Authentication

@testable import govuk_ios

@Suite
struct AuthenticationServiceTests {
    @Test
    func authenticate_success_returningUser_setsTokens() async {
        let mockReturningUserService = MockReturningUserService()
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        let mockUserDefaultsService = MockUserDefaultsService()
        let mockAppConfigService = MockAppConfigService()
        mockAppConfigService.refreshTokenExpirySeconds = 3600
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            authenticatedSecureStoreService: mockSecureStoreService,
            returningUserService: mockReturningUserService,
            userDefaultsService: mockUserDefaultsService,
            appConfigService: mockAppConfigService
        )
        let expectedAccessToken = "access_token_value"
        let expectedRefreshToken = "refresh_token_value"
        let expectedIdToken = Self.idToken
        let expectedExpiryDate = "2099-01-01T00:00:00Z"
        let jsonString = """
        {
            "accessToken": "\(expectedAccessToken)",
            "refreshToken": "\(expectedRefreshToken)",
            "idToken": "\(expectedIdToken)",
            "tokenType": "id_token",
            "expiryDate": "\(expectedExpiryDate)"
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        let tokenResponse = createTokenResponse(jsonData)
        mockAuthClient._stubbedAuthenticationResult = AuthenticationResult.success(tokenResponse)
        let result = await sut.authenticate(window: UIApplication.shared.window!)

        await confirmation() { confirmation in
            if case .success(let serviceResult) = result {
                #expect(sut.refreshToken == expectedRefreshToken)
                #expect(sut.idToken == expectedIdToken)
                #expect(sut.accessToken == expectedAccessToken)
                #expect(sut.isSignedIn)
                #expect(serviceResult.returningUser)

                let date = mockUserDefaultsService.value(forKey: .refreshTokenIssuedAtDate) as? Date
                #expect(date != nil)
                confirmation()
            }
        }
    }

    @Test
    func authenticate_success_noExpiryDate_doesntSetTokenIssueDate() async {
        let mockReturningUserService = MockReturningUserService()
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        let mockUserDefaultsService = MockUserDefaultsService()
        let mockAppConfigService = MockAppConfigService()
        mockAppConfigService.refreshTokenExpirySeconds = nil
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            authenticatedSecureStoreService: mockSecureStoreService,
            returningUserService: mockReturningUserService,
            userDefaultsService: mockUserDefaultsService,
            appConfigService: mockAppConfigService
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
            if case .success = result {
                let date = mockUserDefaultsService.value(forKey: .refreshTokenIssuedAtDate) as? Date
                #expect(date == nil)
                confirmation()
            }
        }
    }

    @Test
    func authenticate_success_newUser_setsTokens() async {
        let mockReturningUserService = MockReturningUserService()
        mockReturningUserService._stubbedReturningUserResult = .success(false)
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            authenticatedSecureStoreService: mockSecureStoreService,
            returningUserService: mockReturningUserService,
            userDefaultsService: MockUserDefaultsService(),
            appConfigService: MockAppConfigService()
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
            if case .success(let serviceResult) = result {
                #expect(sut.refreshToken == expectedRefreshToken)
                #expect(sut.idToken == expectedIdToken)
                #expect(sut.accessToken == expectedAccessToken)
                #expect(sut.isSignedIn)
                #expect(!serviceResult.returningUser)
                confirmation()
            }
        }
    }

    @Test
    func authenticate_success_returningUserServiceError_returnsFailure() async {
        let mockReturningUserService = MockReturningUserService()
        mockReturningUserService._stubbedReturningUserResult = .failure(.coreDataDeletionError)
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            authenticatedSecureStoreService: mockSecureStoreService,
            returningUserService: mockReturningUserService,
            userDefaultsService: MockUserDefaultsService(),
            appConfigService: MockAppConfigService()
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
            if case .failure(let error) = result {
                #expect(error == .returningUserService(.coreDataDeletionError))
                #expect(sut.refreshToken == nil)
                #expect(sut.idToken == nil)
                #expect(sut.accessToken == nil)
                #expect(!sut.isSignedIn)
                confirmation()
            }
        }
    }

    @Test
    func authenticate_serviceClientError_returnsFailure() async {
        let mockReturningUserService = MockReturningUserService()
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        mockAuthClient._stubbedAuthenticationResult = .failure(.loginFlow(.clientError))
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            authenticatedSecureStoreService: mockSecureStoreService,
            returningUserService: mockReturningUserService,
            userDefaultsService: MockUserDefaultsService(),
            appConfigService: MockAppConfigService()
        )
        let result = await sut.authenticate(window: UIApplication.shared.window!)

        await confirmation() { confirmation in
            if case .failure(let error) = result {
                #expect(error == .loginFlow(.clientError))
                confirmation()
            }
        }
    }

    @Test
    func encryptRefreshToken_success_encryptsToken() async {
        let mockReturningUserService = MockReturningUserService()
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            authenticatedSecureStoreService: mockSecureStoreService,
            returningUserService: mockReturningUserService,
            userDefaultsService: MockUserDefaultsService(),
            appConfigService: MockAppConfigService()
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
        let mockReturningUserService = MockReturningUserService()
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            authenticatedSecureStoreService: mockSecureStoreService,
            returningUserService: mockReturningUserService,
            userDefaultsService: MockUserDefaultsService(),
            appConfigService: MockAppConfigService()
        )
        sut.encryptRefreshToken()

        #expect(mockSecureStoreService._savedItems["refreshToken"] == nil)
    }

    @Test
    func encryptRefreshToken_failedEncrypt_doesntEncrypt() async {
        let mockReturningUserService = MockReturningUserService()
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        mockSecureStoreService._stubbedSaveItemResult = .failure(TestSecureStoreError.failedEncrypt)
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            authenticatedSecureStoreService: mockSecureStoreService,
            returningUserService: mockReturningUserService,
            userDefaultsService: MockUserDefaultsService(),
            appConfigService: MockAppConfigService()
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
        sut.encryptRefreshToken()

        #expect(mockSecureStoreService._savedItems["refreshToken"] == nil)
    }

    @Test
    func signOut_deletesRefreshToken() async {
        let mockReturningUserService = MockReturningUserService()
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            authenticatedSecureStoreService: mockSecureStoreService,
            returningUserService: mockReturningUserService,
            userDefaultsService: MockUserDefaultsService(),
            appConfigService: MockAppConfigService()
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
        #expect(sut.refreshToken != nil)
        #expect(mockSecureStoreService._savedItems["refreshToken"] != nil)
        sut.signOut(reason: .userSignout)
        #expect(sut.refreshToken == nil)
        #expect(mockSecureStoreService._savedItems["refreshToken"] == nil)
    }

    @Test
    func tokenRefreshRequest_successful_returnsSuccess() async {
        let mockReturningUserService = MockReturningUserService()
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        let idToken = UUID().uuidString
        let accessToken = UUID().uuidString
        let refreshToken = UUID().uuidString
        let tokenResponse = TokenRefreshResponse(
            accessToken: accessToken,
            idToken: idToken
        )
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            authenticatedSecureStoreService: mockSecureStoreService,
            returningUserService: mockReturningUserService,
            userDefaultsService: MockUserDefaultsService(),
            appConfigService: MockAppConfigService()
        )
        mockAuthClient._stubbedTokenRefreshResult = .success(tokenResponse)
        mockSecureStoreService._stubbedReadItemResult = .success(refreshToken)
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
        let mockReturningUserService = MockReturningUserService()
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
            authenticatedSecureStoreService: mockSecureStoreService,
            returningUserService: mockReturningUserService,
            userDefaultsService: MockUserDefaultsService(),
            appConfigService: MockAppConfigService()
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
        let mockReturningUserService = MockReturningUserService()
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        mockAuthClient._stubbedTokenRefreshResult = .failure(.tokenResponseError)
        mockSecureStoreService._stubbedReadItemResult = .success(UUID().uuidString)
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            authenticatedSecureStoreService: mockSecureStoreService,
            returningUserService: mockReturningUserService,
            userDefaultsService: MockUserDefaultsService(),
            appConfigService: MockAppConfigService()
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

    @Test
    func userEmail_decryptedFromIDToken() async {
        let mockReturningUserService = MockReturningUserService()
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            authenticatedSecureStoreService: mockSecureStoreService,
            returningUserService: mockReturningUserService,
            userDefaultsService: MockUserDefaultsService(),
            appConfigService: MockAppConfigService()
        )
        let expectedAccessToken = "access_token_value"
        let expectedRefreshToken = "refresh_token_value"
        let expectedExpiryDate = "2099-01-01T00:00:00Z"
        let jsonData = """
        {
            "accessToken": "\(expectedAccessToken)",
            "refreshToken": "\(expectedRefreshToken)",
            "idToken": "\(Self.idToken)",
            "tokenType": "id_token",
            "expiryDate": "\(expectedExpiryDate)"
        }
        """.data(using: .utf8)!
        let tokenResponse = createTokenResponse(jsonData)
        mockAuthClient._stubbedAuthenticationResult = .success(tokenResponse)
        _ = await sut.authenticate(window: UIApplication.shared.window!)
        let email = await sut.userEmail

        #expect(email == "josh.dubey1@digital.cabinet-office.gov.uk")
    }

    @Test
    func secureStoreRefreshTokenPresent_returnsTrue() {
        let mockReturningUserService = MockReturningUserService()
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        mockSecureStoreService._stubbedItemExistsResult = true
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            authenticatedSecureStoreService: mockSecureStoreService,
            returningUserService: mockReturningUserService,
            userDefaultsService: MockUserDefaultsService(),
            appConfigService: MockAppConfigService()
        )

        #expect(sut.secureStoreRefreshTokenPresent)
    }

    @Test
    func secureStoreRefreshTokenPresent_returnsFalse() {
        let mockReturningUserService = MockReturningUserService()
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        mockSecureStoreService._stubbedItemExistsResult = false
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            authenticatedSecureStoreService: mockSecureStoreService,
            returningUserService: mockReturningUserService,
            userDefaultsService: MockUserDefaultsService(),
            appConfigService: MockAppConfigService()
        )

        #expect(!sut.secureStoreRefreshTokenPresent)
    }

    @Test
    func shouldAttemptTokenRefresh_noDate_returnsTrue() {
        let mockReturningUserService = MockReturningUserService()
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        mockSecureStoreService._stubbedItemExistsResult = false
        let mockUserDefaults = MockUserDefaultsService()
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            authenticatedSecureStoreService: mockSecureStoreService,
            returningUserService: mockReturningUserService,
            userDefaultsService: mockUserDefaults,
            appConfigService: MockAppConfigService()
        )

        mockUserDefaults.set(nil, forKey: .refreshTokenExpiryDate)
        mockUserDefaults.set(nil, forKey: .refreshTokenIssuedAtDate)

        #expect(sut.shouldAttemptTokenRefresh)
    }

    @Test
    func shouldAttemptTokenRefresh_noIssuedAtDate_expiryDateInPast_returnsFalse() {
        let mockReturningUserService = MockReturningUserService()
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        mockSecureStoreService._stubbedItemExistsResult = false
        let mockUserDefaults = MockUserDefaultsService()
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            authenticatedSecureStoreService: mockSecureStoreService,
            returningUserService: mockReturningUserService,
            userDefaultsService: mockUserDefaults,
            appConfigService: MockAppConfigService()
        )

        let date = Calendar.current.date(byAdding: .second, value: -10, to: .now)!
        mockUserDefaults.set(date, forKey: .refreshTokenExpiryDate)
        mockUserDefaults.set(nil, forKey: .refreshTokenIssuedAtDate)

        #expect(sut.shouldAttemptTokenRefresh == false)
    }

    @Test
    func shouldAttemptTokenRefresh_noIssuedAtDate_expiryDateInFuture_returnsTrue() {
        let mockReturningUserService = MockReturningUserService()
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        mockSecureStoreService._stubbedItemExistsResult = false
        let mockUserDefaults = MockUserDefaultsService()
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            authenticatedSecureStoreService: mockSecureStoreService,
            returningUserService: mockReturningUserService,
            userDefaultsService: mockUserDefaults,
            appConfigService: MockAppConfigService()
        )

        let date = Calendar.current.date(byAdding: .day, value: 1, to: .now)
        mockUserDefaults.set(date, forKey: .refreshTokenExpiryDate)
        mockUserDefaults.set(nil, forKey: .refreshTokenIssuedAtDate)

        #expect(sut.shouldAttemptTokenRefresh)
    }

    @Test
    func shouldAttemptTokenRefresh_issuedAtDateInFuture_noExpiryDate_returnsTrue() {
        let mockReturningUserService = MockReturningUserService()
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        mockSecureStoreService._stubbedItemExistsResult = false
        let mockUserDefaults = MockUserDefaultsService()
        let mockConfigService = MockAppConfigService()
        mockConfigService.refreshTokenExpirySeconds = 3600
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            authenticatedSecureStoreService: mockSecureStoreService,
            returningUserService: mockReturningUserService,
            userDefaultsService: mockUserDefaults,
            appConfigService: mockConfigService
        )

        let date = Calendar.current.date(byAdding: .day, value: 1, to: .now)
        mockUserDefaults.set(nil, forKey: .refreshTokenExpiryDate)
        mockUserDefaults.set(date, forKey: .refreshTokenIssuedAtDate)

        #expect(sut.shouldAttemptTokenRefresh)
    }

    @Test
    func shouldAttemptTokenRefresh_issuedAtDateExpired_noExpiryDate_returnsFalse() {
        let mockReturningUserService = MockReturningUserService()
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        mockSecureStoreService._stubbedItemExistsResult = false
        let mockUserDefaults = MockUserDefaultsService()
        let mockConfigService = MockAppConfigService()
        mockConfigService.refreshTokenExpirySeconds = 1000
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            authenticatedSecureStoreService: mockSecureStoreService,
            returningUserService: mockReturningUserService,
            userDefaultsService: mockUserDefaults,
            appConfigService: mockConfigService
        )

        let date = Calendar.current.date(byAdding: .second, value: -100, to: .now)
        mockUserDefaults.set(nil, forKey: .refreshTokenExpiryDate)
        mockUserDefaults.set(date, forKey: .refreshTokenIssuedAtDate)

        #expect(sut.shouldAttemptTokenRefresh)
    }

    @Test
    func clearRefreshToken_setsRefreshTokenToNil() async {
        let mockReturningUserService = MockReturningUserService()
        let mockAuthClient = MockAuthenticationServiceClient()
        let mockSecureStoreService = MockSecureStoreService()
        mockSecureStoreService._stubbedItemExistsResult = false
        let mockUserDefaults = MockUserDefaultsService()
        let sut = AuthenticationService(
            authenticationServiceClient: mockAuthClient,
            authenticatedSecureStoreService: mockSecureStoreService,
            returningUserService: mockReturningUserService,
            userDefaultsService: mockUserDefaults,
            appConfigService: MockAppConfigService()
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

        #expect(sut.refreshToken != nil)

        sut.clearRefreshToken()

        #expect(sut.refreshToken == nil)
    }
}

private func createTokenResponse(_ jsonData: Data) -> TokenResponse {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    do {
        return try decoder.decode(TokenResponse.self, from: jsonData)
    } catch {
        fatalError("Failed to decode TokenResponse: \(error)")
    }
}

enum TestSecureStoreError: Error {
    case failedDecrypt, failedEncrypt
}

extension AuthenticationServiceTests {
    static var idToken = """
        eyJraWQiOiIxQ2RxbjVRXC9cL2Fqd3kzQ3ZYZGhScnVMTkFhMHpvNXRiNjFiSVhMdWhrUG89IiwiYWxnIjoiUlMyNTYifQ.eyJhdF9oYXNoIjoiZkNJS1NTT2JYcVFKS3g4cUFBSXZhQSIsInN1YiI6Ijg2NDI0MmM0LWQwZDEtNzA1OC04OTgzLThiMzFhMjI4ZTM4MCIsImNvZ25pdG86Z3JvdXBzIjpbImV1LXdlc3QtMl9mSUo2RjI1Wmhfb25lbG9naW4iXSwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAuZXUtd2VzdC0yLmFtYXpvbmF3cy5jb21cL2V1LXdlc3QtMl9mSUo2RjI1WmgiLCJjb2duaXRvOnVzZXJuYW1lIjoib25lbG9naW5fdXJuOmZkYzpnb3YudWs6MjAyMjpmZnNjc3lzcDJvaWZnaGNsYWtpdy0ybXVubHR5cnBhYWJmOXdtYW50bDlrIiwibm9uY2UiOiIyWlVCaEliUGpucVRqd3ZGU2VDT3lJc2tPRDRCazREVXcyM3RUekVDWElnIiwib3JpZ2luX2p0aSI6IjcwMTA5YzIyLWZkMjUtNGY1Ny1iNjU2LWY3NjE2NjQ5NGIyNyIsImF1ZCI6IjEyMWY1MWoxczRrbWs5aTk4dW0wYjVtcGhoIiwiaWRlbnRpdGllcyI6W3siZGF0ZUNyZWF0ZWQiOiIxNzQyODI0MjgxMTkwIiwidXNlcklkIjoidXJuOmZkYzpnb3YudWs6MjAyMjpmRlNDU1lTUDJvSUZnaGNMYWtJVy0ybVVObHRZUlBhQWJmOVdNQW50TDlrIiwicHJvdmlkZXJOYW1lIjoib25lbG9naW4iLCJwcm92aWRlclR5cGUiOiJPSURDIiwiaXNzdWVyIjpudWxsLCJwcmltYXJ5IjoidHJ1ZSJ9XSwidG9rZW5fdXNlIjoiaWQiLCJhdXRoX3RpbWUiOjE3NDU1NzYzMjEsImV4cCI6MTc0NTY2MjcyMSwiaWF0IjoxNzQ1NTc2MzIxLCJqdGkiOiIyMjM2YWRkNC0zZWM5LTQ0OWEtYTI0YS00MWRlZDcwOGQ3ZTEiLCJlbWFpbCI6Impvc2guZHViZXkxQGRpZ2l0YWwuY2FiaW5ldC1vZmZpY2UuZ292LnVrIn0.AchyWXMGUaNZz9NlYAKbzkH9LIiZmucLvQF8j3aLDlf6mQVM17i0ar4MKCsAt4sTeQQoyOCHUOXDT9TjCr2jOFKFG1Yn2uAMj-LNEehMmN4721qTVKiNrwD7zfr1bTB-Awwi15KSl3683vEA4s-gJMAttwLMB_IWJ7w3-fdg-fBehAJNaaJiWexpe4sjmmn5A5s7elxzKQcjXuyKWT28NbkxAJtm2FUX0Z2jI4szc0cBodbK-26Ic_136mTMmAolzRkl7SP83bzRfEKh5Lv_6ZMY-3YhPCJD2kTdqT4VTL5UGQ18QzRWjL2DEtV0_Vd4RJpZrr1xSMG6c9yA2XTBWQ
        """
}

