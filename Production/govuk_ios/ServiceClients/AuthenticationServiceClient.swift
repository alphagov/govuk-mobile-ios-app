import Foundation
import GOVKit
import UIKit
import AppAuth
import Authentication

typealias AuthenticationResult = Result<Authentication.TokenResponse, AuthenticationError>
typealias TokenRefreshResult = Result<OIDTokenResponse, TokenRefreshError>

protocol AuthenticationServiceClientInterface {
    func performAuthenticationFlow(window: UIWindow) async -> AuthenticationResult
    func performTokenRefresh(refreshToken: String) async -> TokenRefreshResult
}

class AuthenticationServiceClient: AuthenticationServiceClientInterface {
    private let appAuthSession: AppAuthSessionWrapperInterface
    private let appEnvironmentService: AppEnvironmentServiceInterface
    private let oidConfigService: OIDAuthorizationServiceWrapperInterface

    init(appEnvironmentService: AppEnvironmentServiceInterface,
         appAuthSession: AppAuthSessionWrapperInterface,
         oidConfigService: OIDAuthorizationServiceWrapperInterface) {
        self.appEnvironmentService = appEnvironmentService
        self.appAuthSession = appAuthSession
        self.oidConfigService = oidConfigService
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
                OIDAuthorizationService.perform(
                    tokenRequest(refreshToken: refreshToken)
                ) { tokenResponse, _ in
                    if let response = tokenResponse {
                        continuation.resume(
                            returning: .success(response)
                        )
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
            scope: nil,
            refreshToken: refreshToken,
            codeVerifier: nil,
            additionalParameters: nil
        )
    }
}

enum AuthenticationError: Error, Equatable {
    case loginFlow(LoginError)
    case genericError
}

enum TokenRefreshError: Error {
    case missingRefreshTokenError
    case tokenResponseError
    case decryptRefreshTokenError
    case genericError
}
