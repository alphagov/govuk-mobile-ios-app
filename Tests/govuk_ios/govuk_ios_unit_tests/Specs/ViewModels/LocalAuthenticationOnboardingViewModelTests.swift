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
        #expect(sut.iconName == "faceid")
        #expect(sut.title == String.onboarding.localized("faceIdEnrolmentTitle"))
        #expect(sut.message == String.onboarding.localized("faceIdEnrolmentMessage"))
        #expect(sut.enrolButtonTitle == String.onboarding.localized("faceIdEnrolmentButtonTitle"))
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
