import Foundation
import LocalAuthentication

@testable import govuk_ios

class MockLocalAuthenticationService: LocalAuthenticationServiceInterface {
    var _stubbedFaceIdSkipped: Bool = false
    var faceIdSkipped: Bool {
        _stubbedFaceIdSkipped
    }

    func setFaceIdSkipped(_ skipped: Bool) {
        _stubbedFaceIdSkipped = skipped
    }

    var _stubbedDeviceCapableAuthType = LocalAuthenticationType.faceID
    var deviceCapableAuthType: LocalAuthenticationType {
        _stubbedDeviceCapableAuthType
    }

    var _stubbedAvailableAuthType = LocalAuthenticationType.faceID
    var availableAuthType: LocalAuthenticationType {
        _stubbedAvailableAuthType
    }

    var _stubbedBiometricsPossible = true
    var biometricsPossible: Bool {
        _stubbedBiometricsPossible
    }

    var _stubbedTouchIdEnabled = true
    var touchIdEnabled: Bool {
        _stubbedTouchIdEnabled
    }

    func setTouchId(enabled: Bool) {
        _stubbedTouchIdEnabled = enabled
    }

    var _stubbedCanEvaluateBiometricsPolicy: Bool = false
    var _stubbedCanEvaluateError: LAError? = nil
    func canEvaluatePolicy(_ policy: LAPolicy) -> (canEvaluate: Bool, error: LAError?) {
        switch policy {
        case .deviceOwnerAuthenticationWithBiometrics:
            (canEvaluate: _stubbedCanEvaluateBiometricsPolicy, error: _stubbedCanEvaluateError)
        default:
            (canEvaluate: false, error: _stubbedCanEvaluateError)
        }
    }

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

    var _stubbedEvaluatePolicyResult: (Bool, Error?) = (true, nil)
    func evaluatePolicy(_ policy: LAPolicy, reason: String, completion: @escaping (Bool, Error?) -> Void) {
        completion(_stubbedEvaluatePolicyResult.0, _stubbedEvaluatePolicyResult.1)
    }

    var _resetLocalAuthenticationOnboardingSeenCalled: Bool = false
    func resetLocalAuthenticationOnboardingSeen() {
        _resetLocalAuthenticationOnboardingSeenCalled = true
    }
}
