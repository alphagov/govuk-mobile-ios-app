import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
struct LocalAuthenticationOnboardingViewModelTests {
    @Test
    func updateBiometryType_forTouchID_setsCorrectValues() {
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAuthType = .touchID
        let mockAuthenticationService = MockAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        let sut = LocalAuthenticationOnboardingViewModel(
            localAuthenticationService: mockLocalAuthenticationService,
            authenticationService: mockAuthenticationService,
            analyticsService: mockAnalyticsService,
            completionAction: { }
        )
        sut.updateAuthType()
        #expect(sut.iconName == "touchid")
        #expect(sut.title == String.onboarding.localized("touchIdEnrolmentTitle"))
        #expect(sut.message == String.onboarding.localized("touchIdEnrolmentMessage"))
        #expect(sut.enrolButtonTitle == String.onboarding.localized("touchIdEnrolmentButtonTitle"))
    }

    @Test
    func updateBiometryType_forFaceID_setsCorrectValues() {
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAuthType = .faceID
        let mockAuthenticationService = MockAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        let sut = LocalAuthenticationOnboardingViewModel(
            localAuthenticationService: mockLocalAuthenticationService,
            authenticationService: mockAuthenticationService,
            analyticsService: mockAnalyticsService,
            completionAction: { }
        )
        sut.updateAuthType()
        #expect(sut.iconName == "faceid")
        #expect(sut.title == String.onboarding.localized("faceIdEnrolmentTitle"))
        #expect(sut.message == String.onboarding.localized("faceIdEnrolmentMessage"))
        #expect(sut.enrolButtonTitle == String.onboarding.localized("faceIdEnrolmentButtonTitle"))
    }

    @Test
    func enrolButtonViewModel_action_encryptionSuccess_encryptsToken() async {
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAuthType = .faceID
        let mockAuthenticationService = MockAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        mockLocalAuthenticationService._stubbedEvaluatePolicyResult = (true, nil)

        let completion = await withCheckedContinuation { continuation in
            let sut = LocalAuthenticationOnboardingViewModel(
                localAuthenticationService: mockLocalAuthenticationService,
                authenticationService: mockAuthenticationService,
                analyticsService: mockAnalyticsService,
                completionAction: { continuation.resume(returning: true) }
            )
            let enrolButtonViewModel = sut.enrolButtonViewModel
            enrolButtonViewModel.action()
        }
        #expect(completion)
        #expect(mockLocalAuthenticationService._setHasSeenOnboardingCalled)
        #expect(mockAuthenticationService._encryptRefreshTokenCallSuccess)
    }

    @Test
    func enrolButtonViewModel_action_encryptionFailure_callsCompletion() async {
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAuthType = .faceID
        let mockAuthenticationService = MockAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        mockLocalAuthenticationService._stubbedEvaluatePolicyResult = (true, nil)
        mockAuthenticationService._encryptRefreshTokenError = .some(NSError())

        let completion = await withCheckedContinuation { continuation in
            let sut = LocalAuthenticationOnboardingViewModel(
                localAuthenticationService: mockLocalAuthenticationService,
                authenticationService: mockAuthenticationService,
                analyticsService: mockAnalyticsService,
                completionAction: { continuation.resume(returning: true) }
            )
            let enrolButtonViewModel = sut.enrolButtonViewModel
            enrolButtonViewModel.action()
        }
        #expect(completion)
        #expect(mockLocalAuthenticationService._setHasSeenOnboardingCalled)
        #expect(!mockAuthenticationService._encryptRefreshTokenCallSuccess)
    }

    @Test
    func skipButtonViewModel_action_callsCompletion() async {
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAuthType = .faceID
        let mockAuthenticationService = MockAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()

        let completion = await withCheckedContinuation { continuation in
            let sut = LocalAuthenticationOnboardingViewModel(
                localAuthenticationService: mockLocalAuthenticationService,
                authenticationService: mockAuthenticationService,
                analyticsService: mockAnalyticsService,
                completionAction: { continuation.resume(returning: true) }
            )
            let skipButtonViewModel = sut.skipButtonViewModel
            skipButtonViewModel.action()
        }
        #expect(completion)
    }
}
