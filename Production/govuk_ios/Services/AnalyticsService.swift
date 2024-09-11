import UIKit
import Logging
import GAnalytics

protocol AnalyticsServiceInterface {
    func configure()
    func track(event: AppEvent)
    func track(screen: TrackableScreen)

    func setAcceptedAnalytics(accepted: Bool)
    var permissionState: AnalyticsPermissionState { get }
}

class AnalyticsService: AnalyticsServiceInterface {
    private let analytics: Logging.AnalyticsService
    private var preferenceStore: UserDefaults

    init(analytics: Logging.AnalyticsService,
         preferenceStore: UserDefaults) {
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

    func track(screen: TrackableScreen) {
        let loggableScreen = screen.toLoggableScreen()
        let params: [String: Any] = [
            "screen_name": screen.trackingName,
            "screen_class": screen.trackingClass,
            "screen_title": screen.trackingTitle,
            "language": screen.trackingLanguage
        ].compactMapValues({ $0 })
        analytics.trackScreen(
            loggableScreen,
            parameters: params
        )
    }

    func setAcceptedAnalytics(accepted: Bool) {
        if accepted {
            analytics.grantAnalyticsPermission()
        } else {
            analytics.denyAnalyticsPermission()
        }
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

struct MappedLoggableScreen: LoggableScreenV2 {
    let name: String
    let type: any ScreenType
}

struct MappedScreenType: ScreenType {
    var name: String
}

extension TrackableScreen {
    func toLoggableScreen() -> LoggableScreenV2 {
        MappedLoggableScreen(
            name: trackingName,
            type: MappedScreenType(name: trackingClass)
        )
    }
}
