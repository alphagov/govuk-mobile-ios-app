import Foundation
import UIKit
import AppAuth
import Authentication

typealias AuthenticationResult = Result<Authentication.TokenResponse, AuthenticationError>

protocol AuthenticationServiceClientInterface {
    func performAuthenticationFlow(window: UIWindow) async -> AuthenticationResult
}

class AuthenticationServiceClient: AuthenticationServiceClientInterface {
    // clientID + issuer will be added to appConfig
    private let appConfig: AppConfigServiceInterface
    private let clientID: String = "replaceID"
    private let issuer: URL = URL(
        string: "https://cognito-idp.eu-west-2.amazonaws.com/eu-west-2_fIJ6F25Zh"
    )!

    private let redirectURI = "govuk://govuk/login-auth-callback"
    private let appAuthSession: AppAuthSessionWrapperInterface
    private let oidConfigService: OIDAuthorizationServiceWrapperInterface

    init(appConfig: AppConfigServiceInterface,
         appAuthSession: AppAuthSessionWrapperInterface,
         oidConfigService: OIDAuthorizationServiceWrapperInterface) {
        self.appConfig = appConfig
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
        } catch AuthenticationError.fetchConfigError {
            return AuthenticationResult.failure(.fetchConfigError)
        } catch let error as LoginError {
            switch error {
            case .userCancelled:
                return AuthenticationResult.failure(.loginFlow(.userCancelled))
            default:
                return AuthenticationResult.failure(
                    .loginFlow(.generic(description: "Login flow error"))
                )
            }
        } catch {
            return AuthenticationResult.failure(.generic)
        }
    }

    private func setConfig() async throws -> LoginSessionConfiguration {
        let idConfig = try await discoverConfiguration()
        return await LoginSessionConfiguration(
            authorizationEndpoint: idConfig.authorizationEndpoint,
            tokenEndpoint: idConfig.tokenEndpoint,
            responseType: .code,
            scopes: [.openid, .email],
            clientID: clientID,
            prefersEphemeralWebSession: true,
            redirectURI: redirectURI,
            locale: .en
        )
    }

    private func discoverConfiguration() async throws -> OIDServiceConfiguration {
        return try await withCheckedThrowingContinuation { continuation in
            oidConfigService.discoverConfiguration(
                forIssuer: issuer
            ) { configuration, _ in
                if let configuration = configuration {
                    continuation.resume(returning: configuration)
                } else {
                    continuation.resume(throwing: AuthenticationError.fetchConfigError)
                }
            }
        }
    }
}

enum AuthenticationError: Error, Equatable {
    case loginFlow(LoginError)
    case fetchConfigError
    case missingAccessToken
    case missingRefreshToken
    case missingIDToken
    case generic
}
