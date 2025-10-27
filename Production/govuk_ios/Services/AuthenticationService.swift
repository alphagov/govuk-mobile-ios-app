import Foundation
import UIKit
import Authentication
import SecureStore
import Factory
import GOVKit

protocol AuthenticationServiceInterface: AnyObject {
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
    private let analyticsService: AnalyticsServiceInterface
    private let appConfigService: AppConfigServiceInterface
    private(set) var refreshToken: String?
    private(set) var idToken: String?
    private(set) var accessToken: String?

    var didSignOutAction: ((SignoutReason) -> Void)?

    var secureStoreRefreshTokenPresent: Bool {
        authenticatedSecureStoreService.hasRefreshToken
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

    init(
        authenticationServiceClient: AuthenticationServiceClientInterface,
        authenticatedSecureStoreService: SecureStorable,
        returningUserService: ReturningUserServiceInterface,
        userDefaultsService: UserDefaultsServiceInterface,
        analyticsService: AnalyticsServiceInterface,
        appConfigService: AppConfigServiceInterface,
    ) {
        self.authenticatedSecureStoreService = authenticatedSecureStoreService
        self.returningUserService = returningUserService
        self.authenticationServiceClient = authenticationServiceClient
        self.userDefaultsService = userDefaultsService
        self.analyticsService = analyticsService
        self.appConfigService = appConfigService
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
            let token = try? await JWTExtractor().extract(jwt: tokenResponse.idToken ?? "")
            saveTokenIssueDate(iat: token?.iat)
            return await handleReturningUser()
        case .failure(let error):
            analyticsService.track(error: error)
            return AuthenticationServiceResult.failure(error)
        }
    }

    func signOut(reason: SignoutReason) {
        do {
            try authenticatedSecureStoreService.delete()
            userDefaultsService.removeObject(forKey: .refreshTokenExpiryDate)
            userDefaultsService.removeObject(forKey: .refreshTokenIssuedAtDate)
            authenticationServiceClient.revokeToken(refreshToken, completion: nil)
            authenticatedSecureStoreService.deleteRefreshToken()
            setTokens()
            authenticatedSecureStoreService = container.authenticatedSecureStoreService.resolve()
            didSignOutAction?(reason)
        } catch {
            analyticsService.track(error: error)
            #if targetEnvironment(simulator)
            // secure store deletion will always fail on simulator
            // as secure enclave unavailable.
            authenticatedSecureStoreService.deleteRefreshToken()
            setTokens()
            #endif
            return
        }
    }

    func encryptRefreshToken() {
        guard let refreshToken = refreshToken
        else { return }
        do {
            try authenticatedSecureStoreService.saveRefreshToken(refreshToken)
        } catch {
            analyticsService.track(error: error)
        }
    }

    func tokenRefreshRequest() async -> TokenRefreshResult {
        let decryptedRefreshToken: String
        do {
            decryptedRefreshToken = try decryptRefreshTokenIfRequired()
        } catch {
            analyticsService.track(error: error)
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
            analyticsService.track(error: error)
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
            analyticsService.track(error: error)
            setTokens()
            return .failure(.returningUserService(error))
        }
    }

    private func decryptRefreshTokenIfRequired() throws -> String {
        try refreshToken ??
        authenticatedSecureStoreService.getRefreshToken()
    }

    private func setTokens(refreshToken: String? = nil,
                           idToken: String? = nil,
                           accessToken: String? = nil) {
        self.refreshToken = refreshToken
        self.idToken = idToken
        self.accessToken = accessToken
    }

    private func saveTokenIssueDate(iat: Date?) {
        userDefaultsService.set(iat, forKey: .refreshTokenIssuedAtDate)
    }

    var shouldAttemptTokenRefresh: Bool {
        guard let date = tokenExpiryDate
        else { return true }
        return date > Date.now
    }

    private var tokenExpiryDate: Date? {
        guard let iat = userDefaultsService.value(forKey: .refreshTokenIssuedAtDate) as? Date,
              let seconds = appConfigService.refreshTokenExpirySeconds
        else { return userDefaultsService.value(forKey: .refreshTokenExpiryDate) as? Date }
        return Calendar.current.date(
            byAdding: .second,
            value: seconds,
            to: iat
        )
    }
}

enum SignoutReason {
    case reauthFailure
    case userSignout
}

extension SecureStorable {
    var hasRefreshToken: Bool {
        checkItemExists(itemName: "refreshToken")
    }

    func getRefreshToken() throws -> String {
        try readItem(itemName: "refreshToken")
    }

    func saveRefreshToken(_ token: String) throws {
        try saveItem(
            item: token,
            itemName: "refreshToken"
        )
    }

    func deleteRefreshToken() {
        deleteItem(itemName: "refreshToken")
    }
}
