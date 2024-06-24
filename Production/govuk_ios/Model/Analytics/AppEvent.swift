import Foundation

import Logging

protocol TrackingEvent: LoggableEvent {
    var params: [String: Any]? { get }
}

struct AppEvent: TrackingEvent {
    let name: String
    let params: [String: Any]?
}
