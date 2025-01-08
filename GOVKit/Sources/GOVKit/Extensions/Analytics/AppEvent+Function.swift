import Foundation

extension AppEvent {
    public static func buttonFunction(text: String,
                                      section: String,
                                      action: String) -> AppEvent {
        function(
            text: text,
            type: "Button",
            section: section,
            action: action
        )
    }

    public static func function(text: String,
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
