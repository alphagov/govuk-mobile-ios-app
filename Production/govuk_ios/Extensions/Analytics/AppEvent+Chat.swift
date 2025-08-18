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

    static func chatAskQuestion(text: String,
                                type: String = "typed") -> AppEvent {
        .init(
            name: "Chat",
            params: [
                "text": text,
                "type": type,
                "action": "Ask Question"
            ]
        )
    }
}
