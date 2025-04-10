import Foundation
import UIKit
import AppAuth
import Authentication

protocol AuthenticationServiceClientInterface {
    func performAuthenticationFlow(
        completion: @escaping (Result<Authentication.TokenResponse, AuthenticationError>) -> Void
    ) async
}

class AuthenticationServiceClient: AuthenticationServiceClientInterface {
    // clientID + issuer will be added to appConfig
    private let appConfig: AppConfigServiceInterface
    private let clientID: String = "replaceID"
    private let issuer: URL = URL(
        string: "https://cognito-idp.eu-west-2.amazonaws.com/eu-west-2_fIJ6F25Zh"
    )!

    private let redirectURI = "govuk://govuk/login-auth-callback"
    private let appAuthSession: LoginSession
    private let oidConfigService: AppOIDConfigServiceInterface
    private var config: LoginSessionConfiguration?

    init(appConfig: AppConfigServiceInterface,
         appAuthSession: LoginSession,
         oidConfigService: AppOIDConfigServiceInterface) {
        self.appConfig = appConfig
        self.appAuthSession = appAuthSession
        self.oidConfigService = oidConfigService
    }

    func performAuthenticationFlow(
        completion: @escaping (Result<Authentication.TokenResponse, AuthenticationError>) -> Void
    ) async {
        do {
            let config = try await setConfig()
            let tokenResponse = try await appAuthSession.performLoginFlow(
                configuration: config
            )
            completion(.success(tokenResponse))
        } catch let error as AuthenticationError {
            completion(.failure(error))
        } catch {
            completion(.failure(.flowError))
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

enum AuthenticationError: Error {
    case fetchConfigError
    case flowError
    case missingAccessToken
    case missingRefreshToken
    case missingIDToken
    case unknown
}
