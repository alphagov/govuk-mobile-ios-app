import SwiftUI
import GOVKit
import UIComponents
import LocalAuthentication

class LocalAuthenticationOnboardingViewModel: ObservableObject {
    @Published var iconName: String = ""
    @Published var title: String = ""
    @Published var message: String = ""
    @Published var enrolButtonTitle: String = ""
    private let userDefaults: UserDefaultsInterface
    private let localAuthenticationService: LocalAuthenticationServiceInterface
    private let authenticationService: AuthenticationServiceInterface
    private var biometryType: LocalAuthenticationType = .none
    private let analyticsService: AnalyticsServiceInterface
    private let completionAction: (() -> Void)
    init(userDefaults: UserDefaultsInterface,
         localAuthenticationService: LocalAuthenticationServiceInterface,
         authenticationService: AuthenticationServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         completionAction: @escaping () -> Void) {
        self.userDefaults = userDefaults
        self.localAuthenticationService = localAuthenticationService
        self.authenticationService = authenticationService
        self.analyticsService = analyticsService
        self.completionAction = completionAction
        updateAuthType()
    }

    var enrolButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(localisedTitle: enrolButtonTitle) { [weak self] in
            self?.localAuthenticationService.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                reason: "Unlock to proceed"
            ) { [weak self] success, _ in
                if success {
                    self?.authenticationService.encryptRefreshToken()
                }

                self?.localAuthenticationService.setLocalAuthenticationOnboarded()
                self?.trackEnrolEvent()
                self?.completionAction()
            }
        }
    }

    var skipButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(localisedTitle: "Skip") { [weak self] in
            self?.localAuthenticationService.setLocalAuthenticationOnboarded()
            self?.trackSkipEvent()
            self?.completionAction()
        }
    }

    private func trackEnrolEvent() {
        let event = AppEvent.buttonNavigation(
            text: enrolButtonTitle,
            external: false
        )
        analyticsService.track(event: event)
    }

    private func trackSkipEvent() {
        let event = AppEvent.buttonNavigation(
            text: "Skip",
            external: false
        )
        analyticsService.track(event: event)
    }

    private func updateAuthType() {
        let authType = localAuthenticationService.availableAuthType
        switch localAuthenticationService.availableAuthType {
        case .touchID:
            iconName = "touchid"
            title = String.onboarding.localized("touchIdEnrolmentTitle")
            message = String.onboarding.localized("touchIdEnrolmentMessage")
            enrolButtonTitle = String.onboarding.localized("touchIdEnrolmentButtonTitle")
        case .faceID:
            iconName = "faceid"
            title = String.onboarding.localized("faceIdEnrolmentTitle")
            message = String.onboarding.localized("faceIdEnrolmentMessage")
            enrolButtonTitle = String.onboarding.localized("faceIdEnrolmentButtonTitle")
        default:
            // should never happen as we only load view model if faceid or touchid enabled
            fatalError("Incompatible auth type: \(authType)")
        }
    }
}
