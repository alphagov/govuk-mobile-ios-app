import Foundation
import LocalAuthentication

@testable import govuk_ios

class MockLAContext: LAContext {
    var _stubbedBiometricsEvaluatePolicyResult = false
    var _stubbedAuthenticationEvaluatePolicyResult = false
    var _stubbedCanEvaluateError: LAError?
    override func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool {
        if let stubbedError = _stubbedCanEvaluateError {
            error?.pointee = stubbedError as NSError
        } else {
            error?.pointee = nil
        }
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

    var _stubbedEvaluatedPolicyDomainState: Data? = nil
    override var evaluatedPolicyDomainState: Data? {
        return _stubbedEvaluatedPolicyDomainState
    }
}
