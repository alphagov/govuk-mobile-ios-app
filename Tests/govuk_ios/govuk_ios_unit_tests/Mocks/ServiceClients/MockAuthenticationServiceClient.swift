import Foundation
import UIKit
import Authentication

@testable import govuk_ios

class MockAuthenticationServiceClient: AuthenticationServiceClientInterface {
    var _stubbedTokenRefreshResult: TokenRefreshResult = .failure(.tokenResponseError)
    func performTokenRefresh(refreshToken: String) async -> TokenRefreshResult {
        _stubbedTokenRefreshResult
    }
    
    var _stubbedAuthenticationResult: AuthenticationResult = .failure(.loginFlow(.clientError))
    func performAuthenticationFlow(window: UIWindow) async -> AuthenticationResult {
        _stubbedAuthenticationResult
    }
}
