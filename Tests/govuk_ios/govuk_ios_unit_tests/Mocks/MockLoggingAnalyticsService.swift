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

    func trackScreen(_ screen: LoggableScreenV2, parameters: [String: Any]) {
        screensVisited.append(screen.name)

        var screenParameters = parameters
        screenParameters["AnalyticsParameterScreenClass"] = screen.type.name
        screenParameters["AnalyticsParameterScreenName"] = screen.name

        screenParamsLogged = screenParameters
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

    func grantAnalyticsPermission() {
        hasAcceptedAnalytics = true
    }

    func denyAnalyticsPermission() {
        hasAcceptedAnalytics = false
    }
}
