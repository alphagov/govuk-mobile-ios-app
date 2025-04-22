import SwiftUI
import GOVKit
import UIComponents

class LocalAuthenticationOnboardingViewModel: ObservableObject {
    @Published var iconName: String = ""
    @Published var title: String = ""
    @Published var message: String = ""
    @Published var enrolButtonTitle: String = ""
    private let localAuthenticationService: LocalAuthenticationServiceInterface
    private let authenticationTokenService: AuthenticationTokenServiceInterface
    private var biometryType: LocalAuthenticationType = .none
    private let analyticsService: AnalyticsServiceInterface
    private let completionAction: (() -> Void)
    init(localAuthenticationService: LocalAuthenticationServiceInterface,
         authenticationTokenService: AuthenticationTokenServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         completionAction: @escaping () -> Void) {
        self.localAuthenticationService = localAuthenticationService
        self.authenticationTokenService = authenticationTokenService
        self.analyticsService = analyticsService
        self.completionAction = completionAction
        updateAuthType()
    }

    var enrolButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(localisedTitle: enrolButtonTitle) {
            self.localAuthenticationService.evaluatePolicy(
                .deviceOwnerAuthentication,
                reason: "Unlock to proceed"
            ) { [weak self] success, _ in
                if success {
                    do {
                        self?.localAuthenticationService.setHasSeenOnboarding()
                        try self?.authenticationTokenService.encryptRefreshToken()
                        self?.completionAction()
                    } catch {
                        self?.completionAction()
                    }
                }
            }
        }
    }

    var skipButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(localisedTitle: "Skip") {
            self.completionAction()
        }
    }

    func updateAuthType() {
        let authType = localAuthenticationService.authType
        switch localAuthenticationService.authType {
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
