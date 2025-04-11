import Foundation
import UIKit
import Authentication

protocol AuthenticationServiceInterface {
    func authenticate() async -> AuthenticationResult
}

class AuthenticationService: AuthenticationServiceInterface {
    private let authenticationServiceClient: AuthenticationServiceClientInterface
    private let authenticationTokenSet: AuthenticationTokenSetInterface

    init(authenticationServiceClient: AuthenticationServiceClientInterface,
         authenticationTokenSet: AuthenticationTokenSetInterface) {
        self.authenticationServiceClient = authenticationServiceClient
        self.authenticationTokenSet = authenticationTokenSet
    }

    func authenticate() async -> AuthenticationResult {
        let result = await authenticationServiceClient.performAuthenticationFlow()
        switch result {
        case .success(let tokenResponse):
            do {
                try handleResult(tokenResponse)
                return AuthenticationResult.success(tokenResponse)
            } catch let error as AuthenticationError {
                return AuthenticationResult.failure(error)
            } catch {
                return AuthenticationResult.failure(.generic)
            }
        case .failure(let error):
            return AuthenticationResult.failure(error)
        }
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
