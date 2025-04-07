import Foundation
import UIKit
import Authentication

protocol AuthenticationServiceInterface {
    func authenticate(
        window: UIWindow,
        completion: @escaping (Result<Authentication.TokenResponse, AuthenticationError>) -> Void
    ) async
}

class AuthenticationService: AuthenticationServiceInterface {
    let authenticationServiceClient: AuthenticationServiceClientInterface

    init(authenticationServiceClient: AuthenticationServiceClientInterface) {
        self.authenticationServiceClient = authenticationServiceClient
    }

    func authenticate(
        window: UIWindow,
        completion: @escaping (Result<Authentication.TokenResponse, AuthenticationError>) -> Void
    ) async {
        await authenticationServiceClient.performAuthenticationFlow(
            window: window,
            completion: { result in
                guard let tokenResponse = try? result.get() else {
                    completion(result)
                    return
                }
                completion(result)
            }
        )
    }
}
