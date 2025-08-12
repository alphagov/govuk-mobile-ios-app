import Foundation
import LocalAuthentication
import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct LocalAuthenticationServiceTests {
    @Test
    func canEvaluatePolicy_withBiometrics() {
        let mockLAContext = MockLAContext()
        let mockUserDefaultsService = MockUserDefaultsService()
        mockLAContext._stubbedBiometricsEvaluatePolicyResult = true
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaultsService,
            context: mockLAContext
        )
        let canEvaluate = sut.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics).canEvaluate
        #expect(canEvaluate)
    }

    @Test
    func canEvaluatePolicy_withAuthentication() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        mockLAContext._stubbedAuthenticationEvaluatePolicyResult = true
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )
        let canEvaluate = sut.canEvaluatePolicy(.deviceOwnerAuthentication).canEvaluate
        #expect(!canEvaluate)
    }

    @Test
    func canEvaluatePolicy_false_withBiometrics() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        mockLAContext._stubbedBiometricsEvaluatePolicyResult = false
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )
        let canEvaluate = sut.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics).canEvaluate
        #expect(!canEvaluate)
    }

    @Test
    func canEvaluatePolicy_false_withAuthentication() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        mockLAContext._stubbedAuthenticationEvaluatePolicyResult = false
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )
        let canEvaluate = sut.canEvaluatePolicy(.deviceOwnerAuthentication).canEvaluate
        #expect(!canEvaluate)
    }

    @Test
    func evaluatePolicy_succeeds() async {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )
        await confirmation("Evaluate policy should complete") { completion in
            sut.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, reason: "Test") { success, error in
                if success {
                    completion()
                }
            }
        }
    }

    @Test
    func authenticationOnboardingFlowSeen_set_returnsTrue() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )
        sut.setLocalAuthenticationOnboarded()

        #expect(sut.authenticationOnboardingFlowSeen)
    }

    @Test
    func authenticationOnboardingFlowSeen_notSet_returnsFalse() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )

        #expect(!sut.authenticationOnboardingFlowSeen)
    }

    @Test
    func setLocalAuthenticationOnboarded_setsValueInUserDefaults() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )
        sut.setLocalAuthenticationOnboarded()

        #expect(mockUserDefaults.bool(forKey: .localAuthenticationOnboardingSeen))
    }

    @Test
    func authenticationOnboardingFlowSeen_returnsValueInUserDefaults() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )
        sut.setLocalAuthenticationOnboarded()

        #expect(sut.authenticationOnboardingFlowSeen)
    }

    @Test
    func availableAuthType_biometricsAvailable_returnsCorrectResult() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )
        mockLAContext._stubbedBiometricsEvaluatePolicyResult = true
        mockLAContext._stubbedBiometryType = .faceID
        #expect(sut.availableAuthType == .faceID)

        mockLAContext._stubbedBiometryType = .touchID
        #expect(sut.availableAuthType == .touchID)

        mockLAContext._stubbedBiometryType = .none
        #expect(sut.availableAuthType == .none)

        if #available(iOS 17.0, *) {
            mockLAContext._stubbedBiometryType = .opticID
            #expect(sut.availableAuthType == .none)
        }
    }

    @Test
    func availableAuthType_authenticationUnavailable_returnsCorrectResult() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )
        mockLAContext._stubbedBiometricsEvaluatePolicyResult = false
        #expect(sut.availableAuthType == .none)
    }

    @Test
    func deviceCapableAuthType_faceId_returnsCorrectResult() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )
        mockLAContext._stubbedBiometryType = .faceID
        #expect(sut.deviceCapableAuthType == .faceID)
    }

    @Test
    func deviceCapableAuthType_touchId_returnsCorrectResult() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )
        mockLAContext._stubbedBiometryType = .touchID
        #expect(sut.deviceCapableAuthType == .touchID)
    }

    @Test
    func biometricsHaveChanged_noExistingState_returnsFalse() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )
        #expect(!sut.biometricsHaveChanged)
    }

    @Test
    func biometricsHaveChanged_changesState_returnsTrue() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        mockUserDefaults.set("oldState".data(using: .utf8), forKey: .biometricsPolicyState)
        mockLAContext._stubbedEvaluatedPolicyDomainState = "newState".data(using: .utf8)
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )
        #expect(sut.biometricsHaveChanged)
    }

    @Test
    func biometricsHaveChanged_unchangedState_returnsFalse() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        mockUserDefaults.set("sameState".data(using: .utf8), forKey: .biometricsPolicyState)
        mockLAContext._stubbedEvaluatedPolicyDomainState = "sameState".data(using: .utf8)
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )
        #expect(!sut.biometricsHaveChanged)
    }

    @Test
    func touchIdEnabled_enabled_returnsTrue() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )
        mockLAContext._stubbedBiometricsEvaluatePolicyResult = true
        mockLAContext._stubbedBiometryType = .touchID
        sut.setTouchId(enabled: true)

        #expect(sut.touchIdEnabled)
    }

    @Test
    func touchIdEnabled_disabled_returnsFalse() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )
        mockLAContext._stubbedBiometricsEvaluatePolicyResult = true
        mockLAContext._stubbedBiometryType = .touchID
        sut.setTouchId(enabled: false)

        #expect(!sut.touchIdEnabled)
    }

    @Test
    func touchIdEnabled_enabled_faceIdBiometryType_returnsFalse() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )
        mockLAContext._stubbedBiometricsEvaluatePolicyResult = true
        mockLAContext._stubbedBiometryType = .faceID
        sut.setTouchId(enabled: true)

        #expect(!sut.touchIdEnabled)
    }

    @Test
    func setTouchId_true_setsValueInUserDefaults() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )
        sut.setTouchId(enabled: true)

        #expect(mockUserDefaults.bool(forKey: .touchIdEnabled))
    }

    @Test
    func setTouchId_false_setsValueInUserDefaults() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )
        sut.setTouchId(enabled: false)

        #expect(!mockUserDefaults.bool(forKey: .touchIdEnabled))
    }

    @Test
    func biometricsPossible_faceId_canEvaluate_returnsTrue() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        mockLAContext._stubbedBiometricsEvaluatePolicyResult = true
        mockLAContext._stubbedBiometryType = .faceID
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )

        #expect(sut.biometricsPossible == true)
    }

    @Test
    func biometricsPossible_touchId_canEvaluate_returnsTrue() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        mockLAContext._stubbedBiometricsEvaluatePolicyResult = true
        mockLAContext._stubbedBiometryType = .touchID
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )

        #expect(sut.biometricsPossible == true)
    }

    @Test
    func biometricsPossible_faceId_notAvailable_returnsTrue() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        mockLAContext._stubbedBiometricsEvaluatePolicyResult = false
        mockLAContext._stubbedCanEvaluateError = LAError(.biometryNotAvailable, userInfo: [:])
        mockLAContext._stubbedBiometryType = .faceID
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )

        #expect(sut.biometricsPossible == true)
    }

    @Test
    func biometricsPossible_touchId_notAvailable_returnsTrue() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        mockLAContext._stubbedBiometricsEvaluatePolicyResult = false
        mockLAContext._stubbedCanEvaluateError = LAError(.biometryNotAvailable, userInfo: [:])
        mockLAContext._stubbedBiometryType = .touchID
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )

        #expect(sut.biometricsPossible == true)
    }

    @Test
    func biometricsPossible_none_notAvailable_returnsFalse() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        mockLAContext._stubbedBiometricsEvaluatePolicyResult = false
        mockLAContext._stubbedCanEvaluateError = LAError(.biometryNotAvailable, userInfo: [:])
        mockLAContext._stubbedBiometryType = .none
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )

        #expect(sut.biometricsPossible == false)
    }

    @Test
    func biometricsPossible_faceId_notEnrolled_returnsFalse() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        mockLAContext._stubbedBiometricsEvaluatePolicyResult = false
        mockLAContext._stubbedCanEvaluateError = LAError(.biometryNotEnrolled, userInfo: [:])
        mockLAContext._stubbedBiometryType = .none
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )

        #expect(sut.biometricsPossible == false)
    }

    @Test
    func faceIdSkipped_returnsTrue() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )
        sut.setFaceIdSkipped(true)

        #expect(sut.faceIdSkipped)
    }

    @Test
    func setFaceIdSkipped_setsValueInUserDefaults() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )
        sut.setFaceIdSkipped(true)

        #expect(mockUserDefaults.bool(forKey: .faceIdSkipped))
    }

    @Test
    func clear_clearsUserDefaults() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaultsService()
        mockUserDefaults._stub(value: true, key: UserDefaultsKeys.localAuthenticationOnboardingSeen.rawValue)
        mockUserDefaults._stub(value: true, key: UserDefaultsKeys.biometricsPolicyState.rawValue)

        let sut = LocalAuthenticationService(
            userDefaultsService: mockUserDefaults,
            context: mockLAContext
        )
        sut.clear()

        #expect(mockUserDefaults.value(forKey: .localAuthenticationOnboardingSeen) == nil)
        #expect(mockUserDefaults.value(forKey: .biometricsPolicyState) == nil)
    }
}
