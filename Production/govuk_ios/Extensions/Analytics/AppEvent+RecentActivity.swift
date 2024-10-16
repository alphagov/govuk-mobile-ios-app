import Foundation

extension AppEvent {
    static func recentActivity(activity: ActivityItem) -> AppEvent {
        .init(
            name: "RecentActivity",
            params: [
                "text": activity.title
            ]
        )
    }
}
