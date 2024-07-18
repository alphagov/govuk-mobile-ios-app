import Foundation

extension DeeplinkDataStore {
    static func red(coordinatorBuilder: CoordinatorBuilder) -> DeeplinkDataStore {
        .init(
            routes: [
                PermitDeeplinkRoute(coordinatorBuilder: coordinatorBuilder)
            ]
        )
    }

    static func driving(coordinatorBuilder: CoordinatorBuilder) -> DeeplinkDataStore {
        .init(
            routes: [
                DrivingDeeplinkRoute(coordinatorBuilder: coordinatorBuilder)
            ]
        )
    }
}
