import Foundation
import GOVKit
import UIKit
import AppAuth
import Authentication

typealias AuthenticationResult = Result<Authentication.TokenResponse, AuthenticationError>

protocol AuthenticationServiceClientInterface {
    func performAuthenticationFlow(window: UIWindow) async -> AuthenticationResult
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
        } catch let error as AuthenticationError {
            return AuthenticationResult.failure(error)
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
            clientID: appEnvironmentService.authenticationClientId,
            prefersEphemeralWebSession: true,
            redirectURI: Constants.API.authenticationCallbackUri,
            locale: .en
        )
    }

    private func discoverConfiguration() async throws -> OIDServiceConfiguration {
        guard let issuerBaseUrl = Constants.API.authenticationIssuerBaseUrl else {
            throw AuthenticationError.missingIssuerBaseURL
        }

        return try await withCheckedThrowingContinuation { continuation in
            oidConfigService.discoverConfiguration(
                 forIssuer: issuerBaseUrl
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
    case missingIssuerBaseURL
    case missingAccessToken
    case missingRefreshToken
    case missingIDToken
    case generic
}
