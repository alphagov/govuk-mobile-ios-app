import Foundation
import LocalAuthentication

@testable import govuk_ios

class MockLocalAuthenticationService: LocalAuthenticationServiceInterface {
    var _stubbedSkipOnboarding = false
    var shouldSkipOnboarding: Bool {
        _stubbedSkipOnboarding
    }

    var _stubbedCanEvaluatePolicy: Bool = true
    func canEvaluatePolicy(_ policy: LAPolicy) -> Bool {
        return _stubbedCanEvaluatePolicy
    }

    var _stubbedEvaluatePolicyResult: (Bool, Error?) = (true, nil)
    func evaluatePolicy(_ policy: LAPolicy, reason: String, completion: @escaping (Bool, Error?) -> Void) {
        completion(_stubbedEvaluatePolicyResult.0, _stubbedEvaluatePolicyResult.1)
    }

    var _stubbedAuthType: LocalAuthenticationType = .none
    var authType: LocalAuthenticationType {
        return _stubbedAuthType
    }

    var _setHasSeenOnboardingCalled: Bool = false
    func setHasSeenOnboarding() {
        _setHasSeenOnboardingCalled = true
    }
}
