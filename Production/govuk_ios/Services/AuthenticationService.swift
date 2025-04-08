import Foundation
import UIKit
import Authentication

protocol AuthenticationServiceInterface {
    func authenticate(
        window: UIWindow,
        completion: @escaping (Result<Void, AuthenticationError>) -> Void
    ) async
}

class AuthenticationService: AuthenticationServiceInterface {
    let authenticationServiceClient: AuthenticationServiceClientInterface
    let tokenService: AuthenticationTokenServiceInterface

    init(authenticationServiceClient: AuthenticationServiceClientInterface,
         tokenService: AuthenticationTokenServiceInterface) {
        self.authenticationServiceClient = authenticationServiceClient
        self.tokenService = tokenService
    }

    func authenticate(
        window: UIWindow,
        completion: @escaping (Result<Void, AuthenticationError>) -> Void
    ) async {
        await authenticationServiceClient.performAuthenticationFlow(
            window: window,
            completion: { [weak self] result in
                guard let self = self else { return }

                do {
                    try self.handleResult(result)
                    completion(.success(()))
                } catch let error as AuthenticationError {
                    completion(.failure(error))
                } catch {
                    completion(.failure(.unknown))
                }
            }
        )
    }

    private func handleResult(
        _ result: Result<Authentication.TokenResponse, AuthenticationError>
    ) throws {
        guard case .success(let tokenResponse) = result
        else { return }

        switch (tokenResponse.accessToken.isEmpty,
                tokenResponse.idToken,
                tokenResponse.refreshToken) {
        case (_, _, nil):
            throw AuthenticationError.missingRefreshToken
        case (_, nil, _):
            throw AuthenticationError.missingIDToken
        case (true, _, _):
            throw AuthenticationError.missingAccessToken
        default:
            tokenService.setTokens(
                refreshToken: tokenResponse.refreshToken!,
                idToken: tokenResponse.idToken!,
                accessToken: tokenResponse.accessToken
            )
        }
    }
}
