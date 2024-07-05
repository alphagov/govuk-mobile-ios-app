import Foundation

extension DeeplinkDataStore {
    static func driving(coordinatorBuilder: CoordinatorBuilder) -> DeeplinkDataStore {
        .init(
            routes: [
                DrivingDeeplinkRoute(coordinatorBuilder: coordinatorBuilder),
                PermitDeeplinkRoute(coordinatorBuilder: coordinatorBuilder)
            ]
        )
    }
}
