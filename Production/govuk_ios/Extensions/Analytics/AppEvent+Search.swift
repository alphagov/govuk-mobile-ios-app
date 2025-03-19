import Foundation
import GOVKit

extension AppEvent {
    static func searchResultNavigation(item: SearchItem) -> AppEvent {
        navigation(
            text: item.title,
            type: "SearchResult",
            external: true,
            additionalParams: [
                "url": item.link.absoluteString
            ]
        )
    }

    static func searchTerm(term: String, type: SearchInvocationType) -> AppEvent {
        search(
            params: [
                "text": term,
                "type": type.rawValue
            ]
        )
    }

    private static func search(params: [String: Any]) -> AppEvent {
        .init(
            name: "Search",
            params: params
        )
    }
}
