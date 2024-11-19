import UIKit

protocol AnalyticsServiceInterface {
    func launch()
    func track(event: AppEvent)
    func track(screen: TrackableScreen)
    func setUserProperty(key: String, value: String)

    func setAcceptedAnalytics(accepted: Bool)
    var permissionState: AnalyticsPermissionState { get }
}

class AnalyticsService: AnalyticsServiceInterface {
    private let clients: [AnalyticsClient]
    private var userDefaults: UserDefaults

    init(clients: [AnalyticsClient],
         userDefaults: UserDefaults) {
        self.clients = clients
        self.userDefaults = userDefaults
        configureEnabled()
    }

    func launch() {
        clients.forEach { $0.launch() }
    }

    func track(event: AppEvent) {
        guard case .accepted = permissionState
        else { return }
        clients.forEach { $0.track(event: event) }
    }

    func track(screen: TrackableScreen) {
        guard case .accepted = permissionState
        else { return }
        clients.forEach { $0.track(screen: screen) }
    }

    func setAcceptedAnalytics(accepted: Bool) {
        userDefaults.set(bool: accepted, forKey: .acceptedAnalytics)
        clients.forEach { $0.setEnabled(enabled: accepted) }
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

    func setUserProperty(key: String,
                         value: String) {
        clients.forEach { $0.setUserProperty(key: key, value: value) }
    }

    private func configureEnabled() {
        let accepted = hasAcceptedAnalytics ?? false
        clients.forEach { $0.setEnabled(enabled: accepted) }
    }

    private var hasAcceptedAnalytics: Bool? {
        // Do not use bool for key here because we need to have an unknown state (nil)
        userDefaults.value(forKey: .acceptedAnalytics) as? Bool
    }
}
