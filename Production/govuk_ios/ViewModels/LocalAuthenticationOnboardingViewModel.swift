import SwiftUI
import GOVKit
import UIComponents
import LocalAuthentication

class LocalAuthenticationOnboardingViewModel: ObservableObject {
    @Published var iconName: String = ""
    @Published var title: String = ""
    @Published var message: String = ""
    @Published var enrolButtonTitle: String = ""
    private let userDefaultsService: UserDefaultsServiceInterface
    private let localAuthenticationService: LocalAuthenticationServiceInterface
    private let authenticationService: AuthenticationServiceInterface
    private var biometryType: LocalAuthenticationType = .none
    private let completionAction: (() -> Void)
    init(userDefaultsService: UserDefaultsServiceInterface,
         localAuthenticationService: LocalAuthenticationServiceInterface,
         authenticationService: AuthenticationServiceInterface,
         completionAction: @escaping () -> Void) {
        self.userDefaultsService = userDefaultsService
        self.localAuthenticationService = localAuthenticationService
        self.authenticationService = authenticationService
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
                    if self?.localAuthenticationService.availableAuthType == .touchID {
                        self?.localAuthenticationService.setTouchId(enabled: true)
                    }
                }

                self?.localAuthenticationService.setLocalAuthenticationOnboarded()
                self?.completionAction()
            }
        }
    }

    var skipButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(localisedTitle: "Skip") { [weak self] in
            if self?.localAuthenticationService.availableAuthType == .touchID {
                self?.localAuthenticationService.setTouchId(enabled: false)
            } else if self?.localAuthenticationService.availableAuthType == .faceID {
                self?.localAuthenticationService.setFaceIdSkipped(true)
            }
            self?.localAuthenticationService.setLocalAuthenticationOnboarded()
            self?.completionAction()
        }
    }

    private func updateAuthType() {
        let authType = localAuthenticationService.availableAuthType
        switch authType {
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
