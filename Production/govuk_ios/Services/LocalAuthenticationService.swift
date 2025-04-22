import Foundation
import LocalAuthentication

enum LocalAuthenticationType {
    case touchID
    case faceID
    case passcodeOnly
    case none
}

protocol LocalAuthenticationServiceInterface {
    func canEvaluatePolicy(_ policy: LAPolicy) -> Bool
    func evaluatePolicy(_ policy: LAPolicy,
                        reason: String,
                        completion: @escaping (Bool, Error?) -> Void)
    var authType: LocalAuthenticationType { get }
    var hasSeenOnboarding: Bool { get }
    func setHasSeenOnboarding()
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
        guard canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics) else {
            return canEvaluatePolicy(.deviceOwnerAuthentication) ?
                .passcodeOnly : .none
        }

        switch context.biometryType {
        case .none:
            return .none
        case .faceID:
            return .faceID
        case .touchID:
            return .touchID
        case .opticID:
            return .none
        @unknown default:
            return .none
        }
    }

    var hasSeenOnboarding: Bool {
        userDefaults.bool(forKey: .localAuthenticationOnboardingSeen)
    }

    func setHasSeenOnboarding() {
        userDefaults.set(bool: true, forKey: .localAuthenticationOnboardingSeen)
    }
}
