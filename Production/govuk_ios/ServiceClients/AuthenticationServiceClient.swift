import Foundation
import GOVKit
import UIKit
import AppAuth
import Authentication

typealias AuthenticationResult = Result<Authentication.TokenResponse, AuthenticationError>
typealias TokenRefreshResult = Result<TokenRefreshResponse, TokenRefreshError>

protocol AuthenticationServiceClientInterface {
    func performAuthenticationFlow(window: UIWindow) async -> AuthenticationResult
    func performTokenRefresh(refreshToken: String) async -> TokenRefreshResult
}

class AuthenticationServiceClient: AuthenticationServiceClientInterface {
    private let appAuthSession: AppAuthSessionWrapperInterface
    private let appEnvironmentService: AppEnvironmentServiceInterface
    private let oidAuthService: OIDAuthorizationServiceWrapperInterface

    init(appEnvironmentService: AppEnvironmentServiceInterface,
         appAuthSession: AppAuthSessionWrapperInterface,
         oidAuthService: OIDAuthorizationServiceWrapperInterface) {
        self.appEnvironmentService = appEnvironmentService
        self.appAuthSession = appAuthSession
        self.oidAuthService = oidAuthService
    }

    func performAuthenticationFlow(window: UIWindow) async -> AuthenticationResult {
        do {
            let session = await appAuthSession.session(window: window)
            let tokenResponse = try await session.performLoginFlow(
                configuration: loginSessionConfig()
            )
            return .success(tokenResponse)
        } catch let error as LoginError {
            return .failure(.loginFlow(error))
        } catch {
            return .failure(.genericError)
        }
    }

    func performTokenRefresh(refreshToken: String) async -> TokenRefreshResult {
        do {
            return try await withCheckedThrowingContinuation { continuation in
                oidAuthService.perform(
                    tokenRequest(refreshToken: refreshToken)
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

    private func loginSessionConfig() async -> LoginSessionConfiguration {
        return await LoginSessionConfiguration(
            authorizationEndpoint: appEnvironmentService.authenticationAuthorizeURL,
            tokenEndpoint: appEnvironmentService.authenticationTokenURL,
            responseType: .code,
            scopes: [.openid, .email],
            clientID: appEnvironmentService.authenticationClientId,
            prefersEphemeralWebSession: true,
            redirectURI: Constants.API.authenticationCallbackUri,
            locale: .en
        )
    }

    private func tokenRequest(refreshToken: String) -> OIDTokenRequest {
        let oidServiceConfig = OIDServiceConfiguration(
            authorizationEndpoint: appEnvironmentService.authenticationAuthorizeURL,
            tokenEndpoint: appEnvironmentService.authenticationTokenURL
        )

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
            additionalParameters: nil
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
    case persistentUserIdentifierError
    case genericError
}

enum TokenRefreshError: Error {
    case missingRefreshTokenError
    case missingAccessTokenError
    case tokenResponseError
    case decryptRefreshTokenError
    case genericError
}
