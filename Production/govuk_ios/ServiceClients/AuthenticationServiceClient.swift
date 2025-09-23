import Foundation
import GOVKit
import UIKit
import AppAuth
import Authentication
import FirebaseAppCheck
import FirebaseCrashlytics

typealias AuthenticationResult = Result<Authentication.TokenResponse, AuthenticationError>
typealias TokenRefreshResult = Result<TokenRefreshResponse, TokenRefreshError>

protocol AuthenticationServiceClientInterface {
    func performAuthenticationFlow(window: UIWindow) async -> AuthenticationResult
    func performTokenRefresh(refreshToken: String) async -> TokenRefreshResult
    func revokeToken(_ refreshToken: String?,
                     completion: (() -> Void)?)
}

class AuthenticationServiceClient: AuthenticationServiceClientInterface {
    private let appAuthSession: AppAuthSessionWrapperInterface
    private let appEnvironmentService: AppEnvironmentServiceInterface
    private let oidAuthService: OIDAuthorizationServiceWrapperInterface
    private let revokeTokenService: APIServiceClientInterface
    private let appAttestService: AppAttestServiceInterface

    init(appEnvironmentService: AppEnvironmentServiceInterface,
         appAuthSession: AppAuthSessionWrapperInterface,
         oidAuthService: OIDAuthorizationServiceWrapperInterface,
         revokeTokenServiceClient: APIServiceClientInterface,
         appAttestService: AppAttestServiceInterface) {
        self.appEnvironmentService = appEnvironmentService
        self.appAuthSession = appAuthSession
        self.oidAuthService = oidAuthService
        self.revokeTokenService = revokeTokenServiceClient
        self.appAttestService = appAttestService
    }

    func performAuthenticationFlow(window: UIWindow) async -> AuthenticationResult {
        do {
            let session = await appAuthSession.session(window: window)
            let tokenResponse = try await session.performLoginFlow(
                configuration: loginSessionConfig()
            )
            logResponse(
                code: 111,
                accessToken: tokenResponse.accessToken,
                refreshToken: tokenResponse.refreshToken,
                idToken: tokenResponse.idToken,
                expiryDate: tokenResponse.expiryDate
            )
            return .success(tokenResponse)
        } catch let error as LoginError {
            return .failure(.loginFlow(error))
        } catch {
            return .failure(.genericError)
        }
    }

    private func logResponse(code: Int,
                             accessToken: String,
                             refreshToken: String?,
                             idToken: String?,
                             expiryDate: Date) {
        let formatter = DateFormatter()
        formatter.timeStyle = .long
        formatter.dateStyle = .medium
        let expiry = formatter.string(from: expiryDate)
        let error = NSError(
            domain: "uk.gov.govuk",
            code: code,
            userInfo: [
                "accessTokenEmpty": accessToken.isEmpty,
                "refreshTokenExists": refreshToken != nil,
                "refreshTokenEmpty": refreshToken?.isEmpty == true,
                "idTokenExists": idToken != nil,
                "idTokenEmpty": idToken?.isEmpty == true,
                "expiryDate": expiry
            ]
        )
        Crashlytics.crashlytics().record(error: error)
    }

    func performTokenRefresh(refreshToken: String) async -> TokenRefreshResult {
        let request = await tokenRequest(refreshToken: refreshToken)
        do {
            return try await withCheckedThrowingContinuation { continuation in
                oidAuthService.perform(
                    request
                ) { [weak self] tokenResponse, error in
                    if let error = error {
                        Crashlytics.crashlytics().record(error: error)
                    }
                    guard let self = self else { return }
                    if let response = tokenResponse {
                        let defaultDate = Date(timeIntervalSince1970: 0)
                        logResponse(
                            code: 222,
                            accessToken: response.accessToken ?? "No token",
                            refreshToken: response.refreshToken,
                            idToken: response.idToken,
                            expiryDate: response.accessTokenExpirationDate ?? defaultDate
                        )
                        do {
                            let tokenRefreshRespnse = try generateTokenRefreshResponse(response)
                            continuation.resume(
                                returning: .success(tokenRefreshRespnse)
                            )
                        } catch {
                            Crashlytics.crashlytics().record(error: error)
                            continuation.resume(
                                throwing: error
                            )
                        }
                    } else {
                        Crashlytics.crashlytics().record(
                            error: TokenRefreshError.tokenResponseError
                        )
                        continuation.resume(
                            throwing: TokenRefreshError.tokenResponseError
                        )
                    }
                }
            }
        } catch let error as TokenRefreshError {
            Crashlytics.crashlytics().record(error: error)
            return .failure(error)
        } catch {
            Crashlytics.crashlytics().record(error: error)
            return .failure(.genericError)
        }
    }

    func revokeToken(_ refreshToken: String?,
                     completion: (() -> Void)?) {
        guard let refreshToken else {
            return
        }
        let request = GOVRequest.revoke(
            refreshToken,
            clientId: appEnvironmentService.authenticationClientId
        )
        revokeTokenService.send(request: request) { result in
            if case .success = result {
                completion?()
            }
        }
    }

    private func loginSessionConfig() async -> LoginSessionConfiguration {
        let token = (try? await appAttestService.token(forcingRefresh: false).token) ?? ""

        return await LoginSessionConfiguration(
            authorizationEndpoint: appEnvironmentService.authenticationAuthorizeURL,
            tokenEndpoint: appEnvironmentService.authenticationTokenURL,
            responseType: .code,
            scopes: [.openid, .email],
            clientID: appEnvironmentService.authenticationClientId,
            prefersEphemeralWebSession: true,
            redirectURI: Constants.API.authenticationCallbackUri,
            locale: .en,
            tokenParameters: ["scope": "openid email"],
            tokenHeaders: ["x-attestation-token": token]
        )
    }

    private func tokenRequest(refreshToken: String) async -> OIDTokenRequest {
        let oidServiceConfig = OIDServiceConfiguration(
            authorizationEndpoint: appEnvironmentService.authenticationAuthorizeURL,
            tokenEndpoint: appEnvironmentService.authenticationTokenURL
        )

        let token = (try? await appAttestService.token(forcingRefresh: false).token) ?? ""

        return OIDTokenRequest(
            configuration: oidServiceConfig,
            grantType: OIDGrantTypeRefreshToken,
            authorizationCode: nil,
            redirectURL: nil,
            clientID: appEnvironmentService.authenticationClientId,
            clientSecret: nil,
            scope: "openid email",
            refreshToken: refreshToken,
            codeVerifier: nil,
            additionalParameters: nil,
            additionalHeaders: ["x-attestation-token": token]
        )
    }

    private func generateTokenRefreshResponse(
        _ token: OIDTokenResponse
    ) throws -> TokenRefreshResponse {
        guard let accessToken = token.accessToken else {
            throw TokenRefreshError.missingAccessTokenError
        }
        return TokenRefreshResponse(accessToken: accessToken, idToken: token.idToken)
    }
}

enum AuthenticationError: Error, Equatable {
    case loginFlow(LoginError)
    case returningUserService(ReturningUserServiceError)
    case genericError
}

enum TokenRefreshError: Error {
    case missingRefreshTokenError
    case missingAccessTokenError
    case tokenResponseError
    case decryptRefreshTokenError
    case genericError
}
