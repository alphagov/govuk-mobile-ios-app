import Foundation
import LocalAuthentication

enum LocalAuthenticationType {
    case touchID
    case faceID
    case passcodeOnly
    case none
}

protocol LocalAuthenticationServiceInterface {
    var authType: LocalAuthenticationType { get }
    var authenticationOnboardingFlowSeen: Bool { get }
    var biometricsHaveChanged: Bool { get }

    func setLocalAuthenticationOnboarded()
    func canEvaluatePolicy(_ policy: LAPolicy) -> Bool
    func evaluatePolicy(_ policy: LAPolicy,
                        reason: String,
                        completion: @escaping (Bool, Error?) -> Void)
}

final class LocalAuthenticationService: LocalAuthenticationServiceInterface {
    private let context: LAContext
    private let userDefaults: UserDefaultsInterface

    init(userDefaults: UserDefaultsInterface,
         context: LAContext = LAContext()) {
        self.context = context
        self.userDefaults = userDefaults
    }

    func canEvaluatePolicy(_ policy: LAPolicy) -> Bool {
        context.canEvaluatePolicy(policy, error: nil)
    }

    func evaluatePolicy(_ policy: LAPolicy,
                        reason: String,
                        completion: @escaping (Bool, Error?) -> Void) {
        context.evaluatePolicy(policy, localizedReason: reason) { success, error in
            completion(success, error)
        }
    }

    var authType: LocalAuthenticationType {
        switch context.biometryType {
        case .faceID:
            return .faceID
        case .touchID:
            return .touchID
        default:
            return .none
        }
    }

    func setLocalAuthenticationOnboarded() {
        userDefaults.set(bool: true, forKey: .localAuthenticationOnboardingSeen)
    }

    var authenticationOnboardingFlowSeen: Bool {
        userDefaults.bool(forKey: .localAuthenticationOnboardingSeen)
    }

    private var biometricsPolicyState: Data? {
        get {
            userDefaults.value(forKey: .biometricsPolicyState) as? Data
        }
        set {
            userDefaults.set(newValue, forKey: .biometricsPolicyState)
        }
    }

    var biometricsHaveChanged: Bool {
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        if biometricsPolicyState == nil {
            biometricsPolicyState = context.evaluatedPolicyDomainState
            return false
        }
        if let domainState = context.evaluatedPolicyDomainState,
           domainState != biometricsPolicyState {
            biometricsPolicyState = domainState
            return true
        }
        return false
    }
}
