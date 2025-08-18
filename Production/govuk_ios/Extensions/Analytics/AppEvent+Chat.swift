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

    static func chatLinkNavigation(text: String,
                                   url: String) -> AppEvent {
        navigation(
            text: text,
            type: "ChatMarkdownLink",
            external: true,
            additionalParams: [
                "url": url
            ]
        )
    }
}
