import Foundation
import UIKit
import Authentication
import SecureStore

protocol AuthenticationServiceInterface {
    var refreshToken: String? { get }
    var idToken: String? { get }
    var accessToken: String? { get }
    var userEmail: String? { get async }

    func authenticate(window: UIWindow) async -> AuthenticationResult
    func signOut()
    func encryptRefreshToken()
}

class AuthenticationService: AuthenticationServiceInterface {
    private let authenticationServiceClient: AuthenticationServiceClientInterface
    private let secureStoreService: SecureStorable
    private(set) var refreshToken: String?
    private(set) var idToken: String?
    private(set) var accessToken: String?

    var userEmail: String? {
        get async {
            guard let payload = try? await JWTExtractor().extract(jwt: self.idToken!)
            else {
                return nil
            }
            return payload.email
        }
    }

    init(authenticationServiceClient: AuthenticationServiceClientInterface,
         secureStoreService: SecureStorable) {
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
        setTokens()
    }

    func encryptRefreshToken() {
        guard let refreshToken = refreshToken else {
            return
        }
        try? secureStoreService.saveItem(item: refreshToken, itemName: "refreshToken")
    }

    private func setTokens(refreshToken: String? = nil,
                           idToken: String? = nil,
                           accessToken: String? = nil) {
        self.refreshToken = refreshToken
        self.idToken = idToken
        self.accessToken = accessToken
    }
}
