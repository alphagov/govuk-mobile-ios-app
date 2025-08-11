import Foundation
import LocalAuthentication

enum LocalAuthenticationType {
    case touchID
    case faceID
    case passcodeOnly
    case none
}

protocol LocalAuthenticationServiceInterface {
    var deviceCapableAuthType: LocalAuthenticationType { get }
    var availableAuthType: LocalAuthenticationType { get }
    var authenticationOnboardingFlowSeen: Bool { get }
    var biometricsHaveChanged: Bool { get }
    var biometricsPossible: Bool { get }
    var touchIdEnabled: Bool { get }
    var faceIdSkipped: Bool { get }

    func setFaceIdSkipped(_ skipped: Bool)
    func setTouchId(enabled: Bool)
    func setLocalAuthenticationOnboarded()
    func canEvaluatePolicy(_ policy: LAPolicy) -> (canEvaluate: Bool, error: LAError?)
    func evaluatePolicy(_ policy: LAPolicy,
                        reason: String,
                        completion: @escaping (Bool, Error?) -> Void)
    func clear()
}

final class LocalAuthenticationService: LocalAuthenticationServiceInterface {
    private let context: LAContext
    private let userDefaults: UserDefaultsServiceInterface

    init(userDefaults: UserDefaultsServiceInterface,
         context: LAContext = LAContext()) {
        self.context = context
        self.userDefaults = userDefaults
    }

    func canEvaluatePolicy(_ policy: LAPolicy) -> (canEvaluate: Bool, error: LAError?) {
        var authError: NSError?
        let canEvaluate = context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics, error: &authError
        )
        let laError = authError as? LAError

        return (canEvaluate, laError)
    }

    func evaluatePolicy(_ policy: LAPolicy,
                        reason: String,
                        completion: @escaping (Bool, Error?) -> Void) {
        context.evaluatePolicy(policy, localizedReason: reason) { success, error in
            completion(success, error)
        }
    }

    var biometricsPossible: Bool {
        let evaluation = canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics
        )

        if evaluation.canEvaluate {
            // Device supports biometrics, app either enrolled or yet to action app enrolement
            switch availableAuthType {
            case .touchID, .faceID:
                return true
            default:
                return false
            }
        } else {
            return isBiometrySetup(error: evaluation.error)
        }
    }

    private func isBiometrySetup(error: LAError?) -> Bool {
        if error?.code == .biometryNotAvailable {
            switch deviceCapableAuthType {
            case .touchID, .faceID:
                // touchID, faceID setup but toggled off
                return true
            default:
                // Biometrics is not available on  device
                return false
            }
        } else {
            return false
        }
    }

    var deviceCapableAuthType: LocalAuthenticationType {
        switch context.biometryType {
        case .faceID:
            return .faceID
        case .touchID:
            return .touchID
        default:
            return .none
        }
    }

    var availableAuthType: LocalAuthenticationType {
        guard canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics).canEvaluate else {
            return .none
        }

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

    func setTouchId(enabled: Bool) {
        userDefaults.set(bool: enabled, forKey: .touchIdEnabled)
    }

    var touchIdEnabled: Bool {
        availableAuthType == .touchID &&
        userDefaults.bool(forKey: .touchIdEnabled)
    }

    func setFaceIdSkipped(_ skipped: Bool) {
        userDefaults.set(bool: skipped, forKey: .faceIdSkipped)
    }

    var faceIdSkipped: Bool {
        userDefaults.bool(forKey: .faceIdSkipped)
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

    func clear() {
        userDefaults.set(nil, forKey: .localAuthenticationOnboardingSeen)
        userDefaults.set(nil, forKey: .biometricsPolicyState)
    }
}
