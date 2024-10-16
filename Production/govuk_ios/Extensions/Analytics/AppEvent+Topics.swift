import Foundation

extension AppEvent {
    static func toggleTopic(title: String,
                            isFavorite: Bool) -> AppEvent {
        toggle(
            text: title,
            section: "Topics",
            isOn: isFavorite
        )
    }
}
