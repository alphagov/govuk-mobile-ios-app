import UIKit
import GOVKit

class AnalyticsService: AnalyticsServiceInterface {
    private let clients: [AnalyticsClient]
    private let userDefaultsService: UserDefaultsServiceInterface
    private let authenticationService: AuthenticationServiceInterface

    init(clients: [AnalyticsClient],
         userDefaultsService: UserDefaultsServiceInterface,
         authenticationService: AuthenticationServiceInterface) {
        self.clients = clients
        self.userDefaultsService = userDefaultsService
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

    func track(error: Error) {
        clients.forEach { $0.track(error: error) }
    }

    func setAcceptedAnalytics(accepted: Bool) {
        userDefaultsService.set(bool: true, forKey: .acceptedAnalytics)
        clients.forEach { $0.setEnabled(enabled: true) }
    }

    func setExistingConsent() {
        clients.forEach { $0.setEnabled(enabled: true) }
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
        userDefaultsService.set(nil, forKey: .acceptedAnalytics)
        clients.forEach { $0.setEnabled(enabled: true) }
    }

    func set(userProperty: UserProperty) {
        clients.forEach { $0.set(userProperty: userProperty) }
    }

    private func configureDisabled() {
        clients.forEach { $0.setEnabled(enabled: true) }
    }

    private var hasAcceptedAnalytics: Bool? {
        // Do not use bool for key here because we need to have an unknown state (nil)
        userDefaultsService.value(forKey: .acceptedAnalytics) as? Bool
    }

    private var shouldTrack: Bool {
        permissionState == .accepted && authenticationService.isSignedIn
    }
}
