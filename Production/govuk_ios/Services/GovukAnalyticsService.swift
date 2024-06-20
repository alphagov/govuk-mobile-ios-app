//
import Logging
import GAnalytics
import UIKit

protocol GovukAnalyticsServiceInterface {
    func configure()
    func logDeviceInformation()
}

enum AppEvents: String, LoggableEvent {
    case appLoaded
}

struct GovukAnalyticsService: GovukAnalyticsServiceInterface {
    private let analytics: AnalyticsService

    init(analytics: AnalyticsService) {
        self.analytics = analytics
    }

    func logDeviceInformation() {
        let device = UIDevice.current

        analytics.logEvent(
            AppEvents.appLoaded as LoggableEvent,
            parameters: [
                "device_name": device.name,
                "device_model": device.model,
                "system_name": device.systemName,
                "system_version": device.systemVersion
            ]
        )
    }

    func configure() {
        (analytics as? GAnalytics)?.configure()
    }
}
