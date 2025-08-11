import Foundation
import UIKit
import Testing
import LocalAuthentication

@testable import govuk_ios

@Suite
struct LocalAuthenticationOnboardingViewModelTests {
    @Test
    func updateBiometryType_forTouchID_setsCorrectValues() {
        let mockUserDefaultsService = MockUserDefaultsService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAvailableAuthType = .touchID
        let mockAuthenticationService = MockAuthenticationService()
        let sut = LocalAuthenticationOnboardingViewModel(
            userDefaults: mockUserDefaultsService,
            localAuthenticationService: mockLocalAuthenticationService,
            authenticationService: mockAuthenticationService,
            completionAction: { }
        )
        #expect(sut.iconName == "touchid")
        #expect(sut.title == String.onboarding.localized("touchIdEnrolmentTitle"))
        #expect(sut.message == String.onboarding.localized("touchIdEnrolmentMessage"))
        #expect(sut.enrolButtonTitle == String.onboarding.localized("touchIdEnrolmentButtonTitle"))
    }

    @Test
    func updateBiometryType_forFaceID_setsCorrectValues() {
        let mockUserDefaults = MockUserDefaultsService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAvailableAuthType = .faceID
        let mockAuthenticationService = MockAuthenticationService()
        let sut = LocalAuthenticationOnboardingViewModel(
            userDefaults: mockUserDefaults,
            localAuthenticationService: mockLocalAuthenticationService,
            authenticationService: mockAuthenticationService,
            completionAction: { }
        )

        #expect(sut.iconName == "faceid")
        #expect(sut.title == String.onboarding.localized("faceIdEnrolmentTitle"))
        #expect(sut.message == String.onboarding.localized("faceIdEnrolmentMessage"))
        #expect(sut.enrolButtonTitle == String.onboarding.localized("faceIdEnrolmentButtonTitle"))
    }

    @Test
    func enrolButtonViewModel_faceID_action_completesEnrolment() async {
        let mockUserDefaults = MockUserDefaultsService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAvailableAuthType = .faceID
        let mockAuthenticationService = MockAuthenticationService()
        let completion = await withCheckedContinuation { continuation in
            let sut = LocalAuthenticationOnboardingViewModel(
                userDefaults: mockUserDefaults,
                localAuthenticationService: mockLocalAuthenticationService,
                authenticationService: mockAuthenticationService,
                completionAction: { continuation.resume(returning: true) }
            )
            let enrolButtonViewModel = sut.enrolButtonViewModel
            enrolButtonViewModel.action()
        }

        #expect(completion)
        #expect(mockLocalAuthenticationService.authenticationOnboardingFlowSeen)
        #expect(mockAuthenticationService._encryptRefreshTokenCallSuccess)
    }

    @Test
    func enrolButtonViewModel_touchID_action_completesEnrolment() async {
        let mockUserDefaults = MockUserDefaultsService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAvailableAuthType = .touchID
        let mockAuthenticationService = MockAuthenticationService()
        let completion = await withCheckedContinuation { continuation in
            let sut = LocalAuthenticationOnboardingViewModel(
                userDefaults: mockUserDefaults,
                localAuthenticationService: mockLocalAuthenticationService,
                authenticationService: mockAuthenticationService,
                completionAction: { continuation.resume(returning: true) }
            )
            let enrolButtonViewModel = sut.enrolButtonViewModel
            enrolButtonViewModel.action()
        }

        #expect(completion)
        #expect(mockLocalAuthenticationService.authenticationOnboardingFlowSeen)
        #expect(mockAuthenticationService._encryptRefreshTokenCallSuccess)
    }

    @Test
    func enrolButtonViewModel_userCancels_action_setsNoLocalAuth() async {
        let mockUserDefaults = MockUserDefaultsService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAvailableAuthType = .faceID
        let mockAuthenticationService = MockAuthenticationService()
        mockLocalAuthenticationService._stubbedEvaluatePolicyResult = (false, LAError(.userCancel))
        let completion = await withCheckedContinuation { continuation in
            let sut = LocalAuthenticationOnboardingViewModel(
                userDefaults: mockUserDefaults,
                localAuthenticationService: mockLocalAuthenticationService,
                authenticationService: mockAuthenticationService,
                completionAction: { continuation.resume(returning: true) }
            )
            let enrolButtonViewModel = sut.enrolButtonViewModel
            enrolButtonViewModel.action()
        }

        #expect(completion)
        #expect(mockLocalAuthenticationService.authenticationOnboardingFlowSeen)
        #expect(!mockAuthenticationService._encryptRefreshTokenCallSuccess)
    }

    @Test
    func skipButtonViewModel_faceId_action_callsCompletion() async {
        let mockUserDefaults = MockUserDefaultsService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAvailableAuthType = .faceID
        let mockAuthenticationService = MockAuthenticationService()
        let completion = await withCheckedContinuation { continuation in
            let sut = LocalAuthenticationOnboardingViewModel(
                userDefaults: mockUserDefaults,
                localAuthenticationService: mockLocalAuthenticationService,
                authenticationService: mockAuthenticationService,
                completionAction: { continuation.resume(returning: true) }
            )
            let skipButtonViewModel = sut.skipButtonViewModel
            skipButtonViewModel.action()
        }

        #expect(completion)
        #expect(!mockAuthenticationService._encryptRefreshTokenCallSuccess)
        #expect(mockLocalAuthenticationService.faceIdSkipped)
    }

    @Test
    func skipButtonViewModel_touchId_action_callsCompletion() async {
        let mockUserDefaults = MockUserDefaultsService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAvailableAuthType = .touchID
        let mockAuthenticationService = MockAuthenticationService()
        let completion = await withCheckedContinuation { continuation in
            let sut = LocalAuthenticationOnboardingViewModel(
                userDefaults: mockUserDefaults,
                localAuthenticationService: mockLocalAuthenticationService,
                authenticationService: mockAuthenticationService,
                completionAction: { continuation.resume(returning: true) }
            )
            let skipButtonViewModel = sut.skipButtonViewModel
            skipButtonViewModel.action()
        }

        #expect(completion)
        #expect(!mockAuthenticationService._encryptRefreshTokenCallSuccess)
        #expect(!mockLocalAuthenticationService.touchIdEnabled)
    }

}
