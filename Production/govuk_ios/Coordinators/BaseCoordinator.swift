import Coordination
import Foundation
import UIKit

class BaseCoordinator: NSObject,
                       UINavigationControllerDelegate,
                       UIAdaptivePresentationControllerDelegate {
    private var childCoordinators: [BaseCoordinator] = []
    private var parentCoordinator: BaseCoordinator?
    private var stackedViewControllers: NSHashTable<UIViewController> = .weakObjects()
    private var root: UINavigationController

    init(navigationController: UINavigationController) {
        self.root = navigationController
        super.init()
        navigationController.presentationController?.delegate = self
    }

    func start() {
        assertionFailure("This needs overriding")
    }

    func start(url: String) {
        assertionFailure("This needs overriding")
    }

    func canHandleLinks(path: String) -> Bool {
        return false
    }

    func handleDeepLink(url: String) {
        assertionFailure("This needs overriding")
    }

    func start(_ coordinator: BaseCoordinator) {
        start(child: coordinator)
    }

    func present(_ coordinator: BaseCoordinator,
                 animated: Bool = true) {
        start(child: coordinator)
        root.present(coordinator.root, animated: animated)
    }

    private func start(child: BaseCoordinator) {
        childCoordinators.append(child)
        child.root.delegate = child
        child.parentCoordinator = self
        child.start()
    }

    func push(_ viewController: UIViewController,
              animated: Bool = true) {
        stackedViewControllers.add(viewController)
        root.pushViewController(viewController, animated: animated)
    }

    func set(_ viewController: UIViewController,
             animated: Bool = true) {
        set([viewController], animated: animated)
    }

    func set(_ viewControllers: [UIViewController],
             animated: Bool = true) {
        viewControllers.forEach {
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

    func finish() {
        parentCoordinator?.childDidFinish(self)
    }

    func childDidFinish(_ child: BaseCoordinator) {
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
            childCoordinators.remove(at: index)
            break
        }
    }
}
