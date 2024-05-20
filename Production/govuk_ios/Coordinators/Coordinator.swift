import Coordination
import Foundation
import UIKit

class Coordinator: NSObject,
                   AnyCoordinator,
                   ParentCoordinator,
                   ChildCoordinator,
                   NavigationCoordinator,
                   UIAdaptivePresentationControllerDelegate {
    var childCoordinators: [any ChildCoordinator] = []
    var parentCoordinator: (any ParentCoordinator)?

    private var stackedViewControllers: NSHashTable<UIViewController> = .weakObjects()

    private(set) var root: UINavigationController

    init(navigationController: UINavigationController) {
        self.root = navigationController
        super.init()
        navigationController.presentationController?.delegate = self
    }

    func start() {
        assertionFailure("This needs overriding")
    }

    func open(_ coordinator: Coordinator) {
        openChildInline(coordinator)
    }

    func openModally(_ coordinator: Coordinator) {
        coordinator.root.delegate = coordinator
        openChildModally(coordinator)
    }

    func push(_ viewController: UIViewController,
              animated: Bool = true) {
        stackedViewControllers.add(viewController)
        root.pushViewController(viewController, animated: animated)
    }

    func set(_ viewControllers: [UIViewController],
             animated: Bool = true) {
        viewControllers.forEach {
            $0.presentationController?.delegate = self
            stackedViewControllers.add($0)
        }
        root.setViewControllers(viewControllers, animated: animated)
    }

    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        guard stackedViewControllers.allObjects.isEmpty ||
              stackedViewControllers.allObjects.filter({ $0.navigationController != nil }).isEmpty
        else { return }
        finish()
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        finish()
    }

    final func didRegainFocus(fromChild child: (any ChildCoordinator)?) { }
}
