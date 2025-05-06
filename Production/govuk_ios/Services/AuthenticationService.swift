import Foundation
import UIKit
import Authentication
import SecureStore

protocol AuthenticationServiceInterface {
    var refreshToken: String? { get }
    var idToken: String? { get }
    var accessToken: String? { get }
    var authenticationOnboardingFlowSeen: Bool { get }
    var userEmail: String? { get async }
    var isSignedIn: Bool { get }
    var isLocalAuthenticationSkipped: Bool { get }

    func authenticate(window: UIWindow) async -> AuthenticationResult
    func signOut()
    func encryptRefreshToken()
    func tokenRefreshRequest() async -> TokenRefreshResult
}

class AuthenticationService: AuthenticationServiceInterface {
    private let authenticationServiceClient: AuthenticationServiceClientInterface
    private let secureStoreService: SecureStorable
    private let userDefaults: UserDefaultsInterface
    private(set) var refreshToken: String?
    private(set) var idToken: String?
    private(set) var accessToken: String?

    var userEmail: String? {
        get async {
            guard let idToken,
                  let payload = try? await JWTExtractor().extract(jwt: idToken)
            else {
                return nil
            }
            return payload.email
        }
    }

    var isSignedIn: Bool {
        refreshToken != nil
    }

    var authenticationOnboardingFlowSeen: Bool {
        userDefaults.bool(forKey: .authenticationOnboardingFlowSeen)
    }

    var isLocalAuthenticationSkipped: Bool {
        userDefaults.bool(forKey: .skipLocalAuthentication)
    }

    init(authenticationServiceClient: AuthenticationServiceClientInterface,
         secureStoreService: SecureStorable,
         userDefaults: UserDefaultsInterface) {
        self.userDefaults = userDefaults
        self.secureStoreService = secureStoreService
        self.authenticationServiceClient = authenticationServiceClient
    }

    func authenticate(window: UIWindow) async -> AuthenticationResult {
        let result = await authenticationServiceClient.performAuthenticationFlow(window: window)
        switch result {
        case .success(let tokenResponse):
            setTokens(
                refreshToken: tokenResponse.refreshToken,
                idToken: tokenResponse.idToken,
                accessToken: tokenResponse.accessToken
            )
            return AuthenticationResult.success(tokenResponse)
        case .failure(let error):
            return AuthenticationResult.failure(error)
        }
    }

    func signOut() {
        secureStoreService.deleteItem(itemName: "refreshToken")
        try? secureStoreService.delete()
        setTokens()
    }

    func encryptRefreshToken() {
        guard let refreshToken = refreshToken else {
            return
        }
        try? secureStoreService.saveItem(item: refreshToken, itemName: "refreshToken")
    }

    func tokenRefreshRequest() async -> TokenRefreshResult {
        var decryptedRefreshToken: String
        do {
            decryptedRefreshToken = try decryptRefreshToken()
        } catch {
            return .failure(.decryptRefreshTokenError)
        }

        let result = await authenticationServiceClient.performTokenRefresh(
            refreshToken: decryptedRefreshToken
        )
        switch result {
        case .success(let tokenResponse):
            setTokens(
                refreshToken: decryptedRefreshToken,
                idToken: tokenResponse.idToken,
                accessToken: tokenResponse.accessToken
            )
            return .success(tokenResponse)
        case .failure(let error):
            return .failure(error)
        }
    }

    private func decryptRefreshToken() throws -> String {
        let fetchedRefreshToken = try secureStoreService.readItem(itemName: "refreshToken")
        return fetchedRefreshToken
    }

    private func setTokens(refreshToken: String? = nil,
                           idToken: String? = nil,
                           accessToken: String? = nil) {
        self.refreshToken = refreshToken
        self.idToken = idToken
        self.accessToken = accessToken
    }
}
