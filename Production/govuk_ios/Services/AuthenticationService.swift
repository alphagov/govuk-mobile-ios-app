import Foundation
import UIKit
import Authentication
import SecureStore
import Factory
import FirebaseCrashlytics

protocol AuthenticationServiceInterface: AnyObject {
    var refreshToken: String? { get }
    var idToken: String? { get }
    var accessToken: String? { get }
    var userEmail: String? { get async }
    var isSignedIn: Bool { get }
    var secureStoreRefreshTokenPresent: Bool { get }
    var shouldAttemptTokenRefresh: Bool { get }
    var didSignOutAction: ((SignoutReason) -> Void)? { get set }

    func authenticate(window: UIWindow) async -> AuthenticationServiceResult
    func signOut(reason: SignoutReason)
    func encryptRefreshToken()
    func tokenRefreshRequest() async -> TokenRefreshResult
    func clearRefreshToken()
}

struct AuthenticationServiceResponse {
    let returningUser: Bool
}

typealias AuthenticationServiceResult = Result<AuthenticationServiceResponse, AuthenticationError>

class AuthenticationService: AuthenticationServiceInterface {
    private let container = Container.shared
    private var authenticatedSecureStoreService: SecureStorable
    private let authenticationServiceClient: AuthenticationServiceClientInterface
    private let returningUserService: ReturningUserServiceInterface
    private let userDefaultsService: UserDefaultsServiceInterface
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
         returningUserService: ReturningUserServiceInterface,
         userDefaultsService: UserDefaultsServiceInterface) {
        self.authenticatedSecureStoreService = authenticatedSecureStoreService
        self.returningUserService = returningUserService
        self.authenticationServiceClient = authenticationServiceClient
        self.userDefaultsService = userDefaultsService
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
            do {
                let token = try await JWTExtractor().extract(jwt: tokenResponse.idToken ?? "")
                saveExpiryDate(issueDate: token.iat)
                return await handleReturningUser()
            } catch {
                Crashlytics.crashlytics().record(error: error)
                return AuthenticationServiceResult.failure(.genericError)
            }
        case .failure(let error):
            Crashlytics.crashlytics().record(error: error)
            return AuthenticationServiceResult.failure(error)
        }
    }

    func signOut(reason: SignoutReason) {
        do {
            try authenticatedSecureStoreService.delete()
            userDefaultsService.removeObject(forKey: .refreshTokenExpiryDate)
            authenticationServiceClient.revokeToken(refreshToken, completion: nil)
            authenticatedSecureStoreService.deleteItem(itemName: "refreshToken")
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
        try? authenticatedSecureStoreService.saveItem(
            item: refreshToken,
            itemName: "refreshToken"
        )
    }

    func tokenRefreshRequest() async -> TokenRefreshResult {
        var decryptedRefreshToken: String
        do {
            decryptedRefreshToken = try decryptRefreshTokenIfRequired()
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

    func clearRefreshToken() {
        refreshToken = nil
    }

    private func handleReturningUser() async -> AuthenticationServiceResult {
        let returningUserResult = await returningUserService.process(
            idToken: idToken
        )
        switch returningUserResult {
        case .success(let isReturning):
            return .success(.init(returningUser: isReturning))
        case .failure(let error):
            Crashlytics.crashlytics().record(error: error)
            setTokens()
            return .failure(.returningUserService(error))
        }
    }

    private func decryptRefreshTokenIfRequired() throws -> String {
        guard let token = refreshToken else {
            let fetchedRefreshToken =
            try authenticatedSecureStoreService.readItem(itemName: "refreshToken")
            return fetchedRefreshToken
        }
        return token
    }

    private func setTokens(refreshToken: String? = nil,
                           idToken: String? = nil,
                           accessToken: String? = nil) {
        self.refreshToken = refreshToken
        self.idToken = idToken
        self.accessToken = accessToken
    }

    private func saveExpiryDate(issueDate: Date?) {
        let date = Calendar.current.date(
            byAdding: .second,
            value: 601_200,
            to: issueDate ?? .now
        )
        userDefaultsService.set(date, forKey: UserDefaultsKeys.refreshTokenExpiryDate)
    }

    var shouldAttemptTokenRefresh: Bool {
        guard let date = userDefaultsService.value(forKey: .refreshTokenExpiryDate) as? Date
        else { return true }
        return date > Date.now
    }
}

enum SignoutReason {
    case reauthFailure
    case userSignout
}
