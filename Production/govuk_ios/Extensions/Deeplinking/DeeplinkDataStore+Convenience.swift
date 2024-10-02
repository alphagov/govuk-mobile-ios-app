import Foundation

extension DeeplinkDataStore {
    static func home(coordinatorBuilder: CoordinatorBuilder) -> DeeplinkDataStore {
        .init(
            routes: [
                HomeDeeplinkRoute(coordinatorBuilder: coordinatorBuilder)
            ]
        )
    }

    static func settings(coordinatorBuilder: CoordinatorBuilder) -> DeeplinkDataStore {
        .init(
            routes: [
                SettingsDeeplinkRoute(coordinatorBuilder: coordinatorBuilder)
            ]
        )
    }
}
