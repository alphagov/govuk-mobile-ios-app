import XCTest
import Logging

final class MockLoggingAnalyticsService: Logging.AnalyticsService {
    var additionalParameters = [String: Any]()
    private(set) var screensVisited = [String]()
    private(set) var screenParamsLogged: [String: Any]?
    private(set) var eventsLogged = [String]()
    private(set) var eventsParamsLogged: [String: Any]?
    private(set) var crashesLogged = [NSError]()
    var hasAcceptedAnalytics: Bool?

    func trackScreen(_ screen: LoggableScreen, title: String?) {
        screensVisited.append(screen.name)
    }

    func trackScreen(_ screen: LoggableScreen, parameters: [String: Any] = [:]) {
        screensVisited.append(screen.name)

        screenParamsLogged = parameters
    }

    var _trackScreenV2ReceivedScreens: [LoggableScreenV2] = []
    var _trackScreenV2ReceivedParameters: [[String: Any]] = []
    func trackScreen(_ screen: LoggableScreenV2, parameters: [String: Any]) {
        _trackScreenV2ReceivedScreens.append(screen)
        _trackScreenV2ReceivedParameters.append(parameters)
    }


    func logEvent(_ event: LoggableEvent, parameters: [String: Any]) {
        eventsLogged.append(event.name)

        eventsParamsLogged = parameters
    }

    func logCrash(_ crash: NSError) {
        crashesLogged.append(crash)
    }

    func logCrash(_ crash: Error) {
        crashesLogged.append(crash as NSError)
    }

    var _receivedGrantAnalyticsPermission: Bool = false
    func grantAnalyticsPermission() {
        _receivedGrantAnalyticsPermission = true
        hasAcceptedAnalytics = true
    }

    var _receivedDenyAnalyticsPermission: Bool = false
    func denyAnalyticsPermission() {
        _receivedDenyAnalyticsPermission = true
        hasAcceptedAnalytics = false
    }
}
