import UIKit
import GOVKit

class AnalyticsService: AnalyticsServiceInterface {
    private let clients: [AnalyticsClient]
    private var userDefaults: UserDefaultsInterface
    private let authenticationService: AuthenticationServiceInterface

    init(clients: [AnalyticsClient],
         userDefaults: UserDefaultsInterface,
         authenticationService: AuthenticationServiceInterface) {
        self.clients = clients
        self.userDefaults = userDefaults
        self.authenticationService = authenticationService
        configureDisabled()
    }

    func launch() {
        clients.forEach { $0.launch() }
    }

    func track(event: AppEvent) {
        guard shouldTrack else { return }
        clients.forEach { $0.track(event: event) }
    }

    func track(screen: TrackableScreen) {
        guard shouldTrack else { return }
        clients.forEach { $0.track(screen: screen) }
    }

    func setAcceptedAnalytics(accepted: Bool) {
        userDefaults.set(bool: accepted, forKey: .acceptedAnalytics)
        clients.forEach { $0.setEnabled(enabled: accepted) }
    }

    func setExistingConsent() {
        let accepted = permissionState == .accepted || permissionState == .denied
        if accepted {
            userDefaults.set(bool: accepted, forKey: .acceptedAnalytics)
            clients.forEach { $0.setEnabled(enabled: accepted) }
        }
    }

    var permissionState: AnalyticsPermissionState {
        switch hasAcceptedAnalytics {
        case .none:
            return .unknown
        case .some(true):
            return .accepted
        case .some(false):
            return .denied
        }
    }

    func resetConsent() {
        userDefaults.set(nil, forKey: .acceptedAnalytics)
    }

    func set(userProperty: UserProperty) {
        clients.forEach { $0.set(userProperty: userProperty) }
    }

    private func configureDisabled() {
        clients.forEach { $0.setEnabled(enabled: false) }
    }

    private var hasAcceptedAnalytics: Bool? {
        // Do not use bool for key here because we need to have an unknown state (nil)
        userDefaults.value(forKey: .acceptedAnalytics) as? Bool
    }

    private var shouldTrack: Bool {
        if permissionState == .accepted && authenticationService.isSignedIn {
            true
        } else {
            false
        }
    }
}
