import Foundation

import Logging

struct AppEvent: LoggableEvent {
    let name: String
    let params: [String: Any]?
}
