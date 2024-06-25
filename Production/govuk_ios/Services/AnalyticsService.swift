import Logging
import GAnalytics
import UIKit

protocol AnalyticsServiceInterface {
    func configure()
    func track(event: AppEvent)

    func setAcceptedAnalytics(accepted: Bool)
    var permissionState: AnalyticsPermissionState { get }
}

class AnalyticsService: AnalyticsServiceInterface {
    private let analytics: Logging.AnalyticsService
    private var preferenceStore: AnalyticsPreferenceStore

    init(analytics: Logging.AnalyticsService,
         preferenceStore: AnalyticsPreferenceStore) {
        self.analytics = analytics
        self.preferenceStore = preferenceStore
    }

    func configure() {
        let mappedAnalytics = analytics as? GAnalytics
        mappedAnalytics?.configure()
    }

    func track(event: AppEvent) {
        analytics.logEvent(
            event,
            parameters: event.params ?? [:]
        )
    }

    func setAcceptedAnalytics(accepted: Bool) {
        preferenceStore.hasAcceptedAnalytics = accepted
    }

    var permissionState: AnalyticsPermissionState {
        switch preferenceStore.hasAcceptedAnalytics {
        case .none:
            return .unknown
        case .some(true):
            return .accepted
        case .some(false):
            return .denied
        }
    }
}
