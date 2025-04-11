import Foundation
import UIKit

extension DeeplinkDataStore {
    static func home(coordinatorBuilder: CoordinatorBuilder,
                     root: UIViewController) -> DeeplinkDataStore {
        DeeplinkDataStore(
            routes: [
                HomeDeeplinkRoute(coordinatorBuilder: coordinatorBuilder),
                WebDeeplinkRoute(coordinatorBuilder: coordinatorBuilder)
            ],
            root: root
        )
    }

    static func settings(coordinatorBuilder: CoordinatorBuilder,
                         root: UIViewController) -> DeeplinkDataStore {
        DeeplinkDataStore(
            routes: [
                SettingsDeeplinkRoute(coordinatorBuilder: coordinatorBuilder)
            ],
            root: root
        )
    }
}
