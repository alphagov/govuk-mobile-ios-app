import Foundation
import UIKit

protocol DeepLink {
    var path: String { get }
    func action(parent: BaseCoordinator)
}

struct TestDeepLink: DeepLink {
    var path: String { "/test" }

    func action(parent: BaseCoordinator) {
        let coordinator = DeeplinkCoordinator(
            navigationController: parent.root
        )
        parent.start(coordinator)
    }
}

struct DrivingDeepLink: DeepLink {
    var path: String { "/driving" }

    func action(parent: BaseCoordinator) {
        let coordinator = DrivingCoordinator(
            navigationController: parent.root
        )
        parent.start(coordinator)
    }
}

struct PermitDeepLink: DeepLink {
    var path: String { "/driving/permit/123" }

    func action(parent: BaseCoordinator) {
        let coordinator = PermitCoordinator(
            navigationController: .init()
        )
        parent.present(coordinator)
    }
}
