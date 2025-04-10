import Foundation
import UIKit

extension DeeplinkDataStore {
    static func home(coordinatorBuilder: CoordinatorBuilder,
                     viewControllerBuilder: ViewControllerBuilder,
                     root: UIViewController) -> DeeplinkDataStore {
        let dataStore = DeeplinkDataStore(
            routes: [
                HomeDeeplinkRoute(coordinatorBuilder: coordinatorBuilder)
            ],
            viewControllerBuilder: viewControllerBuilder,
            root: root
        )

        // Add WebDeeplinkRoute with dataStore dependency
        let routes = dataStore.routes + [WebDeeplinkRoute(dataStore: dataStore)]
        return DeeplinkDataStore(
            routes: routes,
            viewControllerBuilder: dataStore.viewControllerBuilder,
            root: dataStore.root
        )
    }

    static func settings(coordinatorBuilder: CoordinatorBuilder,
                         viewControllerBuilder: ViewControllerBuilder,
                         root: UIViewController) -> DeeplinkDataStore {
        let dataStore = DeeplinkDataStore(
            routes: [
                SettingsDeeplinkRoute(coordinatorBuilder: coordinatorBuilder)
            ],
            viewControllerBuilder: viewControllerBuilder,
            root: root
        )

        return dataStore
    }

    static func web(viewControllerBuilder: ViewControllerBuilder,
                    root: UIViewController) -> DeeplinkDataStore {
        let dataStore = DeeplinkDataStore(
            routes: [],
            viewControllerBuilder: viewControllerBuilder,
            root: root
        )

        return dataStore
    }

//    private static func addWebRoute(to dataStore: DeeplinkDataStore) -> DeeplinkDataStore {
//        let routes = dataStore.routes + [WebDeeplinkRoute(dataStore: dataStore)]
//        return DeeplinkDataStore(
//            routes: routes,
//            viewControllerBuilder: dataStore.viewControllerBuilder,
//            root: dataStore.root
//        )
//    }
}
