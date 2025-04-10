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
    private let authenticationTokenSet: AuthenticationTokenSetInterface

    init(authenticationServiceClient: AuthenticationServiceClientInterface,
         authenticationTokenSet: AuthenticationTokenSetInterface) {
        self.authenticationServiceClient = authenticationServiceClient
        self.authenticationTokenSet = authenticationTokenSet
    }

    func authenticate(
        completion: @escaping (Result<Void, AuthenticationError>) -> Void
    ) async {
        await authenticationServiceClient.performAuthenticationFlow(
            completion: { [weak self] result in
                switch result {
                case .success(let tokenResponse):
                    do {
                        try self?.handleResult(tokenResponse)
                        completion(.success(()))
                    } catch let error as AuthenticationError {
                        completion(.failure(error))
                    } catch {
                        completion(.failure(.generic))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }

    private func handleResult(_ tokenResponse: TokenResponse) throws {
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
            authenticationTokenSet.setTokens(
                refreshToken: tokenResponse.refreshToken!,
                idToken: tokenResponse.idToken!,
                accessToken: tokenResponse.accessToken
            )
        }
    }
}
