import Foundation
import UIKit
import Authentication
import SecureStore
import Factory

protocol AuthenticationServiceInterface: AnyObject {
    var refreshToken: String? { get }
    var idToken: String? { get }
    var accessToken: String? { get }
    var userEmail: String? { get async }
    var isSignedIn: Bool { get }
    var secureStoreRefreshTokenPresent: Bool { get }
    var didSignOutAction: ((SignoutReason) -> Void)? { get set }

    func authenticate(window: UIWindow) async -> AuthenticationServiceResult
    func signOut(reason: SignoutReason)
    func encryptRefreshToken()
    func tokenRefreshRequest() async -> TokenRefreshResult
}

struct AuthenticationServiceResponse {
    let returningUser: Bool
}

typealias AuthenticationServiceResult = Result<AuthenticationServiceResponse, AuthenticationError>

class AuthenticationService: AuthenticationServiceInterface {
    private let container = Container.shared
    private var authenticatedSecureStoreService: SecureStorable
    private let localAuthenticationService: LocalAuthenticationServiceInterface
    private let authenticationServiceClient: AuthenticationServiceClientInterface
    private let returningUserService: ReturningUserServiceInterface
    private(set) var refreshToken: String?
    private(set) var idToken: String?
    private(set) var accessToken: String?

    var didSignOutAction: ((SignoutReason) -> Void)?

    var secureStoreRefreshTokenPresent: Bool {
        authenticatedSecureStoreService.checkItemExists(itemName: "refreshToken")
    }

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

    init(authenticationServiceClient: AuthenticationServiceClientInterface,
         authenticatedSecureStoreService: SecureStorable,
         localAuthenticationService: LocalAuthenticationServiceInterface,
         returningUserService: ReturningUserServiceInterface) {
        self.authenticatedSecureStoreService = authenticatedSecureStoreService
        self.localAuthenticationService = localAuthenticationService
        self.returningUserService = returningUserService
        self.authenticationServiceClient = authenticationServiceClient
    }

    func authenticate(window: UIWindow) async -> AuthenticationServiceResult {
        let result = await authenticationServiceClient.performAuthenticationFlow(window: window)
        switch result {
        case .success(let tokenResponse):
            setTokens(
                refreshToken: tokenResponse.refreshToken,
                idToken: tokenResponse.idToken,
                accessToken: tokenResponse.accessToken
            )
            return await handleReturningUser()
        case .failure(let error):
            return AuthenticationServiceResult.failure(error)
        }
    }

    private func handleReturningUser() async -> AuthenticationServiceResult {
        let returningUserResult = await returningUserService.process(
            idToken: idToken
        )
        switch returningUserResult {
        case .success(let isReturning):
            return .success(.init(returningUser: isReturning))
        case .failure(let error):
            setTokens()
            return .failure(.returningUserService(error))
        }
    }

    func signOut(reason: SignoutReason) {
        do {
            try authenticatedSecureStoreService.delete()
            authenticationServiceClient.revokeToken(refreshToken, completion: nil)
            authenticatedSecureStoreService.deleteItem(itemName: "refreshToken")
            localAuthenticationService.clear()
            setTokens()
            authenticatedSecureStoreService = container.authenticatedSecureStoreService.resolve()
            didSignOutAction?(reason)
        } catch {
            #if targetEnvironment(simulator)
            // secure store deletion will always fail on simulator
            // as secure enclave unavailable.
            authenticatedSecureStoreService.deleteItem(itemName: "refreshToken")
            setTokens()
            #endif
            return
        }
    }

    func encryptRefreshToken() {
        guard let refreshToken = refreshToken else {
            return
        }
        try? authenticatedSecureStoreService.saveItem(item: refreshToken, itemName: "refreshToken")
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
        let fetchedRefreshToken =
        try authenticatedSecureStoreService.readItem(itemName: "refreshToken")
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

enum SignoutReason {
    case reauthFailure
    case userSignout
}
