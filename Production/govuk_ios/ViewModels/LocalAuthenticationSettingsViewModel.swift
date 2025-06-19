import SwiftUI
import GOVKit
import LocalAuthentication

class LocalAuthenticationSettingsViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var buttonTitle: String = ""
    @Published var body: String = ""
    @Published var showSettingsAlert = false
    @Published var touchIdEnabled: Bool = false

    private let authenticationService: AuthenticationServiceInterface
    private let localAuthenticationService: LocalAuthenticationServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    private let urlOpener: URLOpener

    private var biometryType: LocalAuthenticationType = .none

    init(authenticationService: AuthenticationServiceInterface,
         localAuthenticationService: LocalAuthenticationServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         urlOpener: URLOpener) {
        self.urlOpener = urlOpener
        self.authenticationService = authenticationService
        self.localAuthenticationService = localAuthenticationService
        self.analyticsService = analyticsService
        updateAuthType()
        updateTouchIdEnabledStatus()
    }

    func faceIdButtonAction() {
        trackNavigationEvent(buttonTitle, external: false)
        if authenticationService.secureStoreRefreshToken {
            showSettingsAlert = true
        } else {
            localAuthenticationService.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                reason: "Unlock to proceed"
            ) { [weak self] success, error in
                guard let self = self else { return }
                if success {
                    self.authenticationService.encryptRefreshToken()
                } else {
                    // biometrics available but not app enrolled
                    if let error = error as? LAError, error.code == .biometryNotAvailable {
                        DispatchQueue.main.async {
                            self.showSettingsAlert = true
                        }
                    }
                }
            }
        }
    }

    func touchIdToggleAction(enabled: Bool) {
        trackNavigationEvent(buttonTitle, external: false)
        if authenticationService.secureStoreRefreshToken || enabled == false {
            localAuthenticationService.setTouchId(enabled: enabled)
            return
        }

        localAuthenticationService.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            reason: "Unlock to proceed"
        ) { [weak self] success, _ in
            if success {
                self?.authenticationService.encryptRefreshToken()
                self?.localAuthenticationService.setTouchId(enabled: true)
                DispatchQueue.main.async {
                    self?.touchIdEnabled = true
                }
            } else {
                self?.localAuthenticationService.setTouchId(enabled: false)
                DispatchQueue.main.async {
                    self?.touchIdEnabled = false
                }
            }
        }
    }

    func openSettings() {
        urlOpener.openSettings()
        showSettingsAlert = false
    }

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }

    private func updateAuthType() {
        let authType = localAuthenticationService.deviceCapableAuthType
        switch localAuthenticationService.deviceCapableAuthType {
        case .touchID:
            title = String.settings.localized("touchIdTitle")
            body = String.settings.localized("localAuthenticationTouchIdBody")
            buttonTitle = String.settings.localized("localAuthenticationTouchIdButtonTitle")
        case .faceID:
            title = String.settings.localized("faceIdTitle")
            body = String.settings.localized("localAuthenticationFaceIdBody")
            buttonTitle = String.settings.localized("localAuthenticationFaceIdButtonTitle")
        default:
            // should never happen as we only load settings if faceid or touchid available
            fatalError("Incompatible auth type: \(authType)")
        }
    }

    private func updateTouchIdEnabledStatus() {
        touchIdEnabled = localAuthenticationService.touchIdEnabled
    }

    private func trackNavigationEvent(_ title: String,
                                      external: Bool) {
        let event = AppEvent.buttonNavigation(
            text: title,
            external: external
        )
        analyticsService.track(event: event)
    }
}
