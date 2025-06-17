import Foundation
import LocalAuthentication

@testable import govuk_ios

class MockLocalAuthenticationService: LocalAuthenticationServiceInterface {
    var _stubbedAuthenticationOnboardingSeen: Bool = false
    var authenticationOnboardingFlowSeen: Bool {
        _stubbedAuthenticationOnboardingSeen
    }

    func setLocalAuthenticationOnboarded() {
        _stubbedAuthenticationOnboardingSeen = true
    }

    var _stubbedBiometricsHaveChanged = false
    var biometricsHaveChanged: Bool {
        _stubbedBiometricsHaveChanged
    }

    var _stubbedCanEvaluateBiometricsPolicy: Bool = false
    var _stubbedCanEvaluatePasscodePolicy: Bool = false
    func canEvaluatePolicy(_ policy: LAPolicy) -> Bool {
        switch policy {
        case .deviceOwnerAuthenticationWithBiometrics:
            _stubbedCanEvaluateBiometricsPolicy
        case .deviceOwnerAuthentication:
            _stubbedCanEvaluatePasscodePolicy
        default:
            false
        }
    }

    var _stubbedEvaluatePolicyResult: (Bool, Error?) = (true, nil)
    func evaluatePolicy(_ policy: LAPolicy, reason: String, completion: @escaping (Bool, Error?) -> Void) {
        completion(_stubbedEvaluatePolicyResult.0, _stubbedEvaluatePolicyResult.1)
    }

    var _stubbedAuthType: LocalAuthenticationType = .none
    var authType: LocalAuthenticationType {
        return _stubbedAuthType
    }
}
