import Foundation
import GOVKit

extension AppEvent {
    static func chatActionButtonFunction(text: String,
                                         action: String) -> AppEvent {
        buttonFunction(
            text: text,
            section: "Action Menu",
            action: action
        )
    }
}
