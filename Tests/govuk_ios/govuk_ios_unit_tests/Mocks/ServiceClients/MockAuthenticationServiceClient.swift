import Foundation
import UIKit
import Authentication

@testable import govuk_ios

class MockAuthenticationServiceClient: AuthenticationServiceClientInterface {
    var _stubbedResult: AuthenticationResult = .failure(.generic)
    func performAuthenticationFlow(window: UIWindow) async -> govuk_ios.AuthenticationResult {
        _stubbedResult
    }
}
