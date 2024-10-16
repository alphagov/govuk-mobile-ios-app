import UIKit
import Foundation

extension AppEvent {
    static var appLoaded: AppEvent {
        let deviceModel = DeviceModel()

        return .init(
            name: "app_loaded",
            params: [
                "device_model": deviceModel.description
            ]
        )
    }

    static func tabNavigation(text: String) -> AppEvent {
        navigation(
            text: text,
            type: "Tab",
            external: false
        )
    }

    static func searchItemNavigation(title: String,
                                     url: URL,
                                     external: Bool) -> AppEvent {
        navigation(
            text: title,
            type: "SearchResult",
            external: external,
            additionalParams: ["url": url.absoluteString]
        )
    }

    static func searchTerm(term: String) -> AppEvent {
        search(
            text: term
        )
    }

    static func recentActivity(activity: ActivityItem) -> AppEvent {
        .init(
            name: "RecentActivity",
            params: [
                "text": activity.title
            ]
        )
    }

    static func searchItem(item: SearchItem) -> AppEvent {
        search(
            title: item.title,
            link: item.link
        )
    }

    static func toggleTopic(title: String,
                            isFavorite: Bool) -> AppEvent {
        function(
            text: title,
            type: "toggle",
            section: "Topics",
            action: isFavorite ? "On" : "Off"
        )
    }
}

extension AppEvent {
    static func search(text: String) -> AppEvent {
        search(
            params: [
                "text": text,
                "link": link
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

extension AppEvent {
    static func buttonNavigation(text: String,
                                 external: Bool) -> AppEvent {
        navigation(
            text: text,
            type: "Button",
            external: external
        )
    }

    static func navigation(text: String,
                           type: String,
                           external: Bool,
                           additionalParams: [String: Any?] = [:]) -> AppEvent {
        let params: [String: Any?] = [
            "text": text,
            "type": type,
            "external": external,
            "language": Locale.current.analyticsLanguageCode
        ].merging(additionalParams) { (current, _) in current }

        return .init(
            name: "Navigation",
            params: params.compactMapValues { $0 }
        )
    }
}

extension AppEvent {
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
