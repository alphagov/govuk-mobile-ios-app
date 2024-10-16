import Foundation

extension AppEvent {
    static func recentActivityButtonFunction(title: String,
                                             action: String) -> AppEvent {
        buttonFunction(
            text: title,
            section: "Pages you've visited",
            action: action
        )
    }

    static func recentActivityNavigation(activity: ActivityItem) -> AppEvent {
        navigation(
            text: activity.title,
            type: "RecentActivity",
            external: true,
            additionalParams: [
                "url": activity.url
            ]
        )
    }
}
