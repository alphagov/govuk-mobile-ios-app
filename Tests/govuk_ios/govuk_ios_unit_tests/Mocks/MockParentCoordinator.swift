import UIKit
import Foundation

import Coordination

class MockParentCoordinator: NSObject,
                             ParentCoordinator,
                             NavigationCoordinator {
    var root: UINavigationController = UINavigationController()

    var childCoordinators: [any Coordination.ChildCoordinator] = []

    func start() { }

    var didRegainHandler: (((any ChildCoordinator)?) -> Void)?
    func didRegainFocus(fromChild child: (any ChildCoordinator)?) {
        didRegainHandler?(child)
    }

}
