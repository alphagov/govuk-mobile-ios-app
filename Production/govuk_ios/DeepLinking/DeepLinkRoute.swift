import Foundation
import UIKit

protocol DeepLinkRoute {
    var path: String { get }
    func action(parent: BaseCoordinator)
}

struct DrivingDeepLink: DeepLinkRoute {
    var path: String { "/driving" }

    func action(parent: BaseCoordinator) {
        let coordinator = DrivingCoordinator(
            navigationController: parent.root
        )
        parent.start(coordinator)
    }
}

struct PermitDeepLink: DeepLinkRoute {
    var path: String { "/driving/permit/123" }

    func action(parent: BaseCoordinator) {
        let coordinator = PermitCoordinator(
            navigationController: .init()
        )
        parent.present(coordinator)
    }
}


struct PermitDeepLink_Complex: DeepLinkRoute {
    var path: String { "/driving/permit/*/anotherPathComponent" }

    var smartPath: [DeepLinkPathComponents] = [.string("driving"), .string("permit"), .wildcard, .string("anotherPathComponent")]

    func action(parent: BaseCoordinator) {
        let coordinator = PermitCoordinator(
            navigationController: .init()
        )
        parent.present(coordinator)
    }
}

enum DeepLinkPathComponents {
    case string(String)
    case wildcard
}


struct DeeplinkKeyValue {
    let previousPathComponent: [String]
    let key: String

    func value(deepLink: DeepLink) -> String {
        var deepLinkPaths = deepLink.pathComponents

        if deepLinkPaths.contains(previousPathComponent) {
        }

        ""
    }
}
