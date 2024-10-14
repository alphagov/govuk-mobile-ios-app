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

    static func buttonNavigation(text: String,
                                 external: Bool) -> AppEvent {
        navigation(
            text: text,
            type: "Button",
            external: external
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

    static func clearRecentActivity() -> AppEvent {
        .init(
            name: "ClearRecentActivity",
            params: nil
        )
    }

    static func searchTerm(term: String) -> AppEvent {
        .init(
            name: "Search",
            params: [
                "text": term
            ]
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
        .init(
            name: "Search",
            params: [
                "title": item.title,
                "link": item.link
            ]
        )
    }
}
