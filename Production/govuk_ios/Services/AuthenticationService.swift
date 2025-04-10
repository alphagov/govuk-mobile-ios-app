import Foundation
import UIKit
import Authentication

protocol AuthenticationServiceInterface {
    func authenticate(
        completion: @escaping (Result<Void, AuthenticationError>) -> Void
    ) async
}

class AuthenticationService: AuthenticationServiceInterface {
    private let authenticationServiceClient: AuthenticationServiceClientInterface
    private let tokenService: AuthenticationTokenServiceInterface

    init(authenticationServiceClient: AuthenticationServiceClientInterface,
         tokenService: AuthenticationTokenServiceInterface) {
        self.authenticationServiceClient = authenticationServiceClient
        self.tokenService = tokenService
    }

    func authenticate(
        completion: @escaping (Result<Void, AuthenticationError>) -> Void
    ) async {
        await authenticationServiceClient.performAuthenticationFlow(
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

        switch (tokenResponse.refreshToken == nil || tokenResponse.refreshToken?.isEmpty == true,
                tokenResponse.idToken == nil || tokenResponse.idToken?.isEmpty == true,
                tokenResponse.accessToken.isEmpty) {
        case (true, _, _):
            throw AuthenticationError.missingRefreshToken
        case (_, true, _):
            throw AuthenticationError.missingIDToken
        case (_, _, true):
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
