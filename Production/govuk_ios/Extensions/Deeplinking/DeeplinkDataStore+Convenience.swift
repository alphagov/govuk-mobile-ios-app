import Foundation
import UIKit

extension DeeplinkDataStore {
    static func home(coordinatorBuilder: CoordinatorBuilder,
                     viewControllerBuilder: ViewControllerBuilder,
                     root: UIViewController) -> DeeplinkDataStore {
        DeeplinkDataStore(
            routes: [
                HomeDeeplinkRoute(coordinatorBuilder: coordinatorBuilder),
                WebDeeplinkRoute(viewControllerBuilder: viewControllerBuilder)
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
