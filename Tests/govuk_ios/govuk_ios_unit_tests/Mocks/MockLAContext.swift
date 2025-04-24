import Foundation
import LocalAuthentication

@testable import govuk_ios

class MockLAContext: LAContext {
    var _stubbedBiometricsEvaluatePolicyResult = false
    var _stubbedAuthenticationEvaluatePolicyResult = false
    override func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool {
        switch policy {
        case .deviceOwnerAuthentication:
            return _stubbedAuthenticationEvaluatePolicyResult
        case .deviceOwnerAuthenticationWithBiometrics:
            return _stubbedBiometricsEvaluatePolicyResult
        default:
            return false
        }
    }

    var _stubbedReply: ((Bool, Error?) -> Void)? = nil
    override func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void) {
        reply(true, nil)
    }

    var _stubbedBiometryType: LABiometryType = .none
    override var biometryType: LABiometryType {
        return _stubbedBiometryType
    }
}
