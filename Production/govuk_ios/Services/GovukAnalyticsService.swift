//
import Logging
import GAnalytics
import UIKit

protocol GovukAnalyticsServiceInterface {
}

enum AppEvents: String, LoggableEvent {
    case appLoaded
}

struct GovukAnalyticsService: GovukAnalyticsServiceInterface {
    var analytics: AnalyticsService = GAnalytics()

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
}
