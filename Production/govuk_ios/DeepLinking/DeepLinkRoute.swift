import Foundation
import UIKit
import OrderedCollections

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


struct PermitDeepLinkComplex: DeepLinkRoute {
    var path: String { "/driving/permit/*/anotherPathComponent" }

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
    let previousPathComponents: [String]

    var valueFormatter: ((String) -> String)?

    func value(deepLink: DeepLink) -> Result<String, Error> {
        var deepLinkPaths: OrderedSet = OrderedSet(arrayLiteral: deepLink.pathComponents)

        if deepLinkPaths.contains(previousPathComponents) {
            guard let last = previousPathComponents.last,
                  let index = deepLinkPaths.lastIndex(of: [last]) else { return
                      .failure(DeepLinkError.pathComponent) }

            guard deepLinkPaths.count > index else { return .failure(DeepLinkError.noValue) }

            guard let result = deepLinkPaths[index + 1].first else {
                return .failure(DeepLinkError.noValue)
            }
            return .success(result)
        }

        return .failure(DeepLinkError.noMatchingPaths)
    }
}
