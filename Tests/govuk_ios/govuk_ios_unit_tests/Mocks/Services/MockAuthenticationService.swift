import Foundation
import UIKit
import Authentication

@testable import govuk_ios

class MockAuthenticationService: AuthenticationServiceInterface {
    var _stubbedResult: AuthenticationResult = .failure(.generic)
    func authenticate(window: UIWindow) async -> govuk_ios.AuthenticationResult {
        _stubbedResult
    }
}
