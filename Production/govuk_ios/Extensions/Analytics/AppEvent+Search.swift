import Foundation

extension AppEvent {
    static func searchTerm(term: String) -> AppEvent {
        search(
            text: term
        )
    }

    static func search(text: String) -> AppEvent {
        search(
            params: [
                "text": text
            ]
        )
    }

    static func search(title: String,
                       link: URL) -> AppEvent {
        search(
            params: [
                "title": title,
                "link": link
            ]
        )
    }

    static func search(params: [String: Any]) -> AppEvent {
        .init(
            name: "Search",
            params: params
        )
    }
}
