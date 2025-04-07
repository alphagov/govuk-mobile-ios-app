import Foundation
import UIKit
import AppAuth
import Authentication

protocol AuthenticationServiceClientInterface {
    func performAuthenticationFlow(
        window: UIWindow,
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
    private var config: LoginSessionConfiguration?

    init(appConfig: AppConfigServiceInterface) {
        self.appConfig = appConfig
    }

    func performAuthenticationFlow(
        window: UIWindow,
        completion: @escaping (Result<Authentication.TokenResponse, AuthenticationError>) -> Void
    ) async {
        do {
            let config = try await setConfig()
            let tokenResponse = try await AppAuthSession(window: window).performLoginFlow(
                configuration: config
            )
            completion(.success(tokenResponse))
        } catch let error as AuthenticationError {
            completion(.failure(error))
        } catch {
            completion(.failure(.authenticationFlowError))
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
            OIDAuthorizationService.discoverConfiguration(
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
    case authenticationFlowError
}
