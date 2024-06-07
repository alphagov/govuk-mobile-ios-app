//

import Foundation
import UIKit

protocol DeepLink {
    var path: String { get }
    func action(parent: BaseCoordinator)
}

struct TestDeeplink: DeepLink {
    var path: String = "/test"

    func action(parent: BaseCoordinator) {
        let coordinator = DeeplinkCoordinator(
            navigationController: parent.root
        )
        parent.start(coordinator)
    }
}
