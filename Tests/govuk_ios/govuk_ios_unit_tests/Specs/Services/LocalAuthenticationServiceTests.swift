import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct LocalAuthenticationServiceTests {
    @Test
    func canEvaluatePolicy_withBiometrics() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaults()
        mockLAContext._stubbedBiometricsEvaluatePolicyResult = true
        let sut = LocalAuthenticationService(
            userDefaults: mockUserDefaults,
            context: mockLAContext
        )
        let canEvaluate = sut.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics)
        #expect(canEvaluate)
    }

    @Test
    func canEvaluatePolicy_withAuthentication() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaults()
        mockLAContext._stubbedAuthenticationEvaluatePolicyResult = true
        let sut = LocalAuthenticationService(
            userDefaults: mockUserDefaults,
            context: mockLAContext
        )
        let canEvaluate = sut.canEvaluatePolicy(.deviceOwnerAuthentication)
        #expect(canEvaluate)
    }

    @Test
    func canEvaluatePolicy_false_withBiometrics() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaults()
        mockLAContext._stubbedBiometricsEvaluatePolicyResult = false
        let sut = LocalAuthenticationService(
            userDefaults: mockUserDefaults,
            context: mockLAContext
        )
        let canEvaluate = sut.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics)
        #expect(!canEvaluate)
    }

    @Test
    func canEvaluatePolicy_false_withAuthentication() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaults()
        mockLAContext._stubbedAuthenticationEvaluatePolicyResult = false
        let sut = LocalAuthenticationService(
            userDefaults: mockUserDefaults,
            context: mockLAContext
        )
        let canEvaluate = sut.canEvaluatePolicy(.deviceOwnerAuthentication)
        #expect(!canEvaluate)
    }

    @Test
    func evaluatePolicy_succeeds() async {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaults()
        let sut = LocalAuthenticationService(
            userDefaults: mockUserDefaults,
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
    func authenticationOnboardingFlowSeen_setsLocalAuthenticationEnabled_returnsTrue() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaults()
        let sut = LocalAuthenticationService(
            userDefaults: mockUserDefaults,
            context: mockLAContext
        )
        sut.setLocalAuthenticationEnabled(true)

        #expect(sut.authenticationOnboardingFlowSeen)
    }

    @Test
    func authenticationOnboardingFlowSeen_featureFlagDisabled_returnsTrue() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaults()
        let sut = LocalAuthenticationService(
            userDefaults: mockUserDefaults,
            context: mockLAContext
        )

        #expect(sut.authenticationOnboardingFlowSeen)
    }

    @Test
    func setLocalAuthenticationEnabled_setsValueInUserDefaults() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaults()
        let sut = LocalAuthenticationService(
            userDefaults: mockUserDefaults,
            context: mockLAContext
        )
        sut.setLocalAuthenticationEnabled(true)

        #expect(mockUserDefaults.bool(forKey: .localAuthenticationEnabled))
    }

    @Test
    func isLocalAuthenticationEnabled_returnsValueInUserDefaults() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaults()
        let sut = LocalAuthenticationService(
            userDefaults: mockUserDefaults,
            context: mockLAContext
        )
        sut.setLocalAuthenticationEnabled(true)

        #expect(sut.isLocalAuthenticationEnabled)
    }

    @Test
    func authType_biometricsAvailable_returnsCorrectResult() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaults()
        let sut = LocalAuthenticationService(
            userDefaults: mockUserDefaults,
            context: mockLAContext
        )
        mockLAContext._stubbedBiometricsEvaluatePolicyResult = true
        mockLAContext._stubbedBiometryType = .faceID
        #expect(sut.authType == .faceID)

        mockLAContext._stubbedBiometryType = .touchID
        #expect(sut.authType == .touchID)

        mockLAContext._stubbedBiometryType = .none
        #expect(sut.authType == .none)

        if #available(iOS 17.0, *) {
            mockLAContext._stubbedBiometryType = .opticID
            #expect(sut.authType == .none)
        }
    }

    @Test
    func authType_authenticationAvailable_returnsCorrectResult() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaults()
        let sut = LocalAuthenticationService(
            userDefaults: mockUserDefaults,
            context: mockLAContext
        )
        mockLAContext._stubbedBiometricsEvaluatePolicyResult = false
        mockLAContext._stubbedAuthenticationEvaluatePolicyResult = true
        #expect(sut.authType == .passcodeOnly)
    }

    @Test
    func authType_authenticationUnavailable_returnsCorrectResult() {
        let mockLAContext = MockLAContext()
        let mockUserDefaults = MockUserDefaults()
        let sut = LocalAuthenticationService(
            userDefaults: mockUserDefaults,
            context: mockLAContext
        )
        mockLAContext._stubbedAuthenticationEvaluatePolicyResult = false
        #expect(sut.authType == .none)
    }
}
