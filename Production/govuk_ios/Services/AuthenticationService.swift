import Foundation
import UIKit
import Authentication
import SecureStore

protocol AuthenticationServiceInterface {
    func authenticate(window: UIWindow) async -> AuthenticationResult
    func encryptRefreshToken() throws
}

protocol AuthenticationTokenSetInterface {
    var refreshToken: String? { get }
    var idToken: String? { get }
    var accessToken: String? { get }
}

class AuthenticationService: AuthenticationServiceInterface {
    private let authenticationServiceClient: AuthenticationServiceClientInterface
    private let secureStoreService: SecureStorable
    private let tokenSet = AuthenticationTokenSet.shared

    init(authenticationServiceClient: AuthenticationServiceClientInterface,
         secureStoreService: SecureStorable) {
        self.secureStoreService = secureStoreService
        self.authenticationServiceClient = authenticationServiceClient
    }

    func authenticate(window: UIWindow) async -> AuthenticationResult {
        let result = await authenticationServiceClient.performAuthenticationFlow(window: window)
        switch result {
        case .success(let tokenResponse):
            tokenSet._setTokens(
                refreshToken: tokenResponse.refreshToken,
                idToken: tokenResponse.idToken,
                accessToken: tokenResponse.accessToken
            )
            return AuthenticationResult.success(tokenResponse)
        case .failure(let error):
            return AuthenticationResult.failure(error)
        }
    }

    func encryptRefreshToken() throws {
        let refreshToken = tokenSet.refreshToken
        guard let refreshToken = refreshToken else {
            throw AuthenticationTokenError.blankRefreshToken
        }
        do {
            try secureStoreService.saveItem(item: refreshToken, itemName: "refreshToken")
        } catch {
            throw error
        }
    }
}

final class AuthenticationTokenSet: AuthenticationTokenSetInterface {
    static let shared = AuthenticationTokenSet()

    fileprivate(set) var refreshToken: String?
    fileprivate(set) var idToken: String?
    fileprivate(set) var accessToken: String?

    private init() {}
}

extension AuthenticationTokenSet {
    fileprivate func _setTokens(
        refreshToken: String? = nil,
        idToken: String? = nil,
        accessToken: String? = nil
    ) {
        self.refreshToken = refreshToken
        self.idToken = idToken
        self.accessToken = accessToken
    }
}

enum AuthenticationTokenError: Error {
    case secureStore(Error)
    case blankRefreshToken
}
