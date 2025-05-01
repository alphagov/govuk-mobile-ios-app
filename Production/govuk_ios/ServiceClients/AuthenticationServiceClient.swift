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
            let config = try await setConfig()
            let session = await appAuthSession.session(window: window)
            let tokenResponse = try await session.performLoginFlow(
                configuration: config
            )
            return AuthenticationResult.success(tokenResponse)
        } catch {
            return returnError(error)
        }
    }

    func performTokenRefresh(refreshToken: String) async -> TokenRefreshResult {
        do {
            let config = try await setConfig()
            let oidServiceConfig = OIDServiceConfiguration(
                authorizationEndpoint: config.authorizationEndpoint,
                tokenEndpoint: config.tokenEndpoint
            )
            let tokenRequest = OIDTokenRequest(
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

            return try await withCheckedThrowingContinuation { continuation in
                OIDAuthorizationService.perform(tokenRequest) { tokenResponse, _ in
                    if let response = tokenResponse {
                        continuation.resume(
                            returning: .success(response)
                        )
                    } else {
                        continuation.resume(
                            returning: .failure(.tokenResponseError)
                        )
                    }
                }
            }
        } catch {
            return .failure(.fetchConfigError)
        }
    }

    private func setConfig() async throws -> LoginSessionConfiguration {
        let idConfig = try await discoverConfiguration()
        return await LoginSessionConfiguration(
            authorizationEndpoint: idConfig.authorizationEndpoint,
            tokenEndpoint: idConfig.tokenEndpoint,
            responseType: .code,
            scopes: [.openid, .email],
            clientID: appEnvironmentService.authenticationClientId,
            prefersEphemeralWebSession: true,
            redirectURI: Constants.API.authenticationCallbackUri,
            locale: .en
        )
    }

    private func discoverConfiguration() async throws -> OIDServiceConfiguration {
        return try await withCheckedThrowingContinuation { continuation in
            oidConfigService.discoverConfiguration(
                forIssuer: Constants.API.authenticationIssuerBaseUrl
            ) { configuration, _ in
                if let configuration = configuration {
                    continuation.resume(returning: configuration)
                } else {
                    continuation.resume(throwing: AuthenticationError.fetchConfigError)
                }
            }
        }
    }

    private func returnError(_ error: Error) -> AuthenticationResult {
        switch error {
        case let error as AuthenticationError:
            return AuthenticationResult.failure(error)
        case let error as LoginError:
            return AuthenticationResult.failure(.loginFlow(error))
        default:
            return AuthenticationResult.failure(.generic)
        }
    }
}

enum AuthenticationError: Error, Equatable {
    case loginFlow(LoginError)
    case fetchConfigError
    case generic
}

enum TokenRefreshError: Error {
    case missingRefreshTokenError
    case tokenResponseError
    case decryptRefreshTokenError
    case fetchConfigError
}
