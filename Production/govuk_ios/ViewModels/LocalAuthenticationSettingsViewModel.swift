import SwiftUI
import GOVKit
import UIComponents
import LocalAuthentication

class LocalAuthenticationSettingsViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var buttonTitle: String = ""
    @Published var body: String = ""
    private let authenticationService: AuthenticationServiceInterface
    private let localAuthenticationService: LocalAuthenticationServiceInterface
    private var biometryType: LocalAuthenticationType = .none
    private let analyticsService: AnalyticsServiceInterface
    private let urlOpener: URLOpener
    init(urlOpener: URLOpener,
         authenticationService: AuthenticationServiceInterface,
         localAuthenticationService: LocalAuthenticationServiceInterface,
         analyticsService: AnalyticsServiceInterface) {
        self.urlOpener = urlOpener
        self.authenticationService = authenticationService
        self.localAuthenticationService = localAuthenticationService
        self.analyticsService = analyticsService
        updateAuthType()
    }

    func buttonAction() {
        switch localAuthenticationService.deviceCapableAuthType {
        case .faceID:
            faceIDAction()
        case .touchID:
            print("something")
        default:
            print("default")
        }
    }

    private func updateAuthType() {
        let authType = localAuthenticationService.deviceCapableAuthType
        switch localAuthenticationService.deviceCapableAuthType {
        case .touchID:
            title = String.settings.localized("localAuthenticationTouchIdTitle")
            body = String.settings.localized("localAuthenticationTouchIdBody")
            buttonTitle = String.settings.localized("localAuthenticationTouchIdButtonTitle")
        case .faceID:
            title = String.settings.localized("localAuthenticationFaceIdTitle")
            body = String.settings.localized("localAuthenticationFaceIdButtonBody")
            buttonTitle = String.settings.localized("localAuthenticationFaceIdButtonTitle")
        default:
            // should never happen as we only load view model if faceid or touchid enabled
            fatalError("Incompatible auth type: \(authType)")
        }
    }

    private func faceIDAction() {
        if authenticationService.secureStoreRefreshToken {
            authenticationService.signOut()
            urlOpener.openSettings()
        } else {
            localAuthenticationService.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                reason: "Unlock to proceed"
            ) { [weak self] success, _ in
                if success {
                    self?.authenticationService.encryptRefreshToken()
                } else {
                    self?.urlOpener.openSettings()
                }
            }
        }
    }
}
