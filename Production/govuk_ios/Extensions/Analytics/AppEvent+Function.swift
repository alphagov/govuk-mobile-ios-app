import Foundation

extension AppEvent {
    static func toggle(text: String,
                       section: String,
                       isOn: Bool) -> AppEvent {
        function(
            text: text,
            type: "toggle",
            section: section,
            action: isOn ? "On" : "Off"
        )
    }

    static func buttonFunction(text: String,
                               section: String,
                               action: String) -> AppEvent {
        function(
            text: text,
            type: "Button",
            section: section,
            action: action
        )
    }

    static func function(text: String,
                         type: String,
                         section: String,
                         action: String) -> AppEvent {
        .init(
            name: "Function",
            params: [
                "text": text,
                "type": type,
                "section": section,
                "action": action
            ]
        )
    }
}
