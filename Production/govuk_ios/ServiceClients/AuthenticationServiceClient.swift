import Foundation
import GOVKit
import UIKit
import AppAuth
import Authentication
import FirebaseAppCheck

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
//            if tokenResponse.refreshToken == nil {
//
//            }
            return .success(tokenResponse)
        } catch let error as LoginError {
            return .failure(.loginFlow(error))
        } catch {
            return .failure(.genericError)
        }
    }

    func performTokenRefresh(refreshToken: String) async -> TokenRefreshResult {
        let request = await tokenRequest(refreshToken: refreshToken)
        do {
            return try await withCheckedThrowingContinuation { continuation in
                oidAuthService.perform(
                    request
                ) { [weak self] tokenResponse, _ in
                    guard let self = self else { return }
                    if let response = tokenResponse {
                        do {
                            let tokenRefreshRespnse = try generateTokenRefreshResponse(response)
                            continuation.resume(
                                returning: .success(tokenRefreshRespnse)
                            )
                        } catch {
                            continuation.resume(
                                throwing: error
                            )
                        }
                    } else {
                        continuation.resume(
                            throwing: TokenRefreshError.tokenResponseError
                        )
                    }
                }
            }
        } catch let error as TokenRefreshError {
            return .failure(error)
        } catch {
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
