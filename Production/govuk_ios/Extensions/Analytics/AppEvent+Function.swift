import Foundation
import GOVKit

extension AppEvent {
    static func toggle(text: String,
                       section: String,
                       isOn: Bool) -> AppEvent {
        function(
            text: text,
            type: "Toggle",
            section: section,
            action: isOn ? "On" : "Off"
        )
    }
}
