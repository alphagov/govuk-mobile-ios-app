import Foundation
import UIKit
import Testing
import LocalAuthentication

@testable import govuk_ios

@Suite
struct LocalAuthenticationOnboardingViewModelTests {
    @Test
    func updateBiometryType_forTouchID_setsCorrectValues() {
        let mockUserDefaults = MockUserDefaults()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAvailableAuthType = .touchID
        let mockAuthenticationService = MockAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        let sut = LocalAuthenticationOnboardingViewModel(
            userDefaults: mockUserDefaults,
            localAuthenticationService: mockLocalAuthenticationService,
            authenticationService: mockAuthenticationService,
            analyticsService: mockAnalyticsService,
            completionAction: { }
        )
        #expect(sut.iconName == "touchid")
        #expect(sut.title == String.onboarding.localized("touchIdEnrolmentTitle"))
        #expect(sut.message == String.onboarding.localized("touchIdEnrolmentMessage"))
        #expect(sut.enrolButtonTitle == String.onboarding.localized("touchIdEnrolmentButtonTitle"))
    }

    @Test
    func updateBiometryType_forFaceID_setsCorrectValues() {
        let mockUserDefaults = MockUserDefaults()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAvailableAuthType = .faceID
        let mockAuthenticationService = MockAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        let sut = LocalAuthenticationOnboardingViewModel(
            userDefaults: mockUserDefaults,
            localAuthenticationService: mockLocalAuthenticationService,
            authenticationService: mockAuthenticationService,
            analyticsService: mockAnalyticsService,
            completionAction: { }
        )

        #expect(sut.iconName == "faceid")
        #expect(sut.title == String.onboarding.localized("faceIdEnrolmentTitle"))
        #expect(sut.message == String.onboarding.localized("faceIdEnrolmentMessage"))
        #expect(sut.enrolButtonTitle == String.onboarding.localized("faceIdEnrolmentButtonTitle"))
    }

    @Test
    func enrolButtonViewModel_faceID_action_completesEnrolment() async {
        let mockUserDefaults = MockUserDefaults()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAvailableAuthType = .faceID
        let mockAuthenticationService = MockAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        let completion = await withCheckedContinuation { continuation in
            let sut = LocalAuthenticationOnboardingViewModel(
                userDefaults: mockUserDefaults,
                localAuthenticationService: mockLocalAuthenticationService,
                authenticationService: mockAuthenticationService,
                analyticsService: mockAnalyticsService,
                completionAction: { continuation.resume(returning: true) }
            )
            let enrolButtonViewModel = sut.enrolButtonViewModel
            enrolButtonViewModel.action()
        }

        #expect(completion)
        #expect(mockLocalAuthenticationService.authenticationOnboardingFlowSeen)
        #expect(mockAuthenticationService._encryptRefreshTokenCallSuccess)
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        let event = mockAnalyticsService._trackedEvents.first
        #expect(event?.params?["text"] as? String == "Allow Face ID")
    }

    @Test
    func enrolButtonViewModel_touchID_action_completesEnrolment() async {
        let mockUserDefaults = MockUserDefaults()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAvailableAuthType = .touchID
        let mockAuthenticationService = MockAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        let completion = await withCheckedContinuation { continuation in
            let sut = LocalAuthenticationOnboardingViewModel(
                userDefaults: mockUserDefaults,
                localAuthenticationService: mockLocalAuthenticationService,
                authenticationService: mockAuthenticationService,
                analyticsService: mockAnalyticsService,
                completionAction: { continuation.resume(returning: true) }
            )
            let enrolButtonViewModel = sut.enrolButtonViewModel
            enrolButtonViewModel.action()
        }

        #expect(completion)
        #expect(mockLocalAuthenticationService.authenticationOnboardingFlowSeen)
        #expect(mockAuthenticationService._encryptRefreshTokenCallSuccess)
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        let event = mockAnalyticsService._trackedEvents.first
        #expect(event?.params?["text"] as? String == "Allow Touch ID")
    }

    @Test
    func enrolButtonViewModel_userCancels_action_setsNoLocalAuth() async {
        let mockUserDefaults = MockUserDefaults()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAvailableAuthType = .faceID
        let mockAuthenticationService = MockAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        mockLocalAuthenticationService._stubbedEvaluatePolicyResult = (false, LAError(.userCancel))
        let completion = await withCheckedContinuation { continuation in
            let sut = LocalAuthenticationOnboardingViewModel(
                userDefaults: mockUserDefaults,
                localAuthenticationService: mockLocalAuthenticationService,
                authenticationService: mockAuthenticationService,
                analyticsService: mockAnalyticsService,
                completionAction: { continuation.resume(returning: true) }
            )
            let enrolButtonViewModel = sut.enrolButtonViewModel
            enrolButtonViewModel.action()
        }

        #expect(completion)
        #expect(mockLocalAuthenticationService.authenticationOnboardingFlowSeen)
        #expect(!mockAuthenticationService._encryptRefreshTokenCallSuccess)
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        let event = mockAnalyticsService._trackedEvents.first
        #expect(event?.params?["text"] as? String == "Allow Face ID")
    }

    @Test
    func skipButtonViewModel_faceId_action_callsCompletion() async {
        let mockUserDefaults = MockUserDefaults()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAvailableAuthType = .faceID
        let mockAuthenticationService = MockAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        let completion = await withCheckedContinuation { continuation in
            let sut = LocalAuthenticationOnboardingViewModel(
                userDefaults: mockUserDefaults,
                localAuthenticationService: mockLocalAuthenticationService,
                authenticationService: mockAuthenticationService,
                analyticsService: mockAnalyticsService,
                completionAction: { continuation.resume(returning: true) }
            )
            let skipButtonViewModel = sut.skipButtonViewModel
            skipButtonViewModel.action()
        }

        #expect(completion)
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(!mockAuthenticationService._encryptRefreshTokenCallSuccess)
        #expect(mockLocalAuthenticationService.faceIdSkipped)
        let event = mockAnalyticsService._trackedEvents.first
        #expect(event?.params?["text"] as? String == "Skip")
    }

    @Test
    func skipButtonViewModel_touchId_action_callsCompletion() async {
        let mockUserDefaults = MockUserDefaults()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAvailableAuthType = .touchID
        let mockAuthenticationService = MockAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        let completion = await withCheckedContinuation { continuation in
            let sut = LocalAuthenticationOnboardingViewModel(
                userDefaults: mockUserDefaults,
                localAuthenticationService: mockLocalAuthenticationService,
                authenticationService: mockAuthenticationService,
                analyticsService: mockAnalyticsService,
                completionAction: { continuation.resume(returning: true) }
            )
            let skipButtonViewModel = sut.skipButtonViewModel
            skipButtonViewModel.action()
        }

        #expect(completion)
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(!mockAuthenticationService._encryptRefreshTokenCallSuccess)
        #expect(!mockLocalAuthenticationService.touchIdEnabled)
        let event = mockAnalyticsService._trackedEvents.first
        #expect(event?.params?["text"] as? String == "Skip")
    }

}
