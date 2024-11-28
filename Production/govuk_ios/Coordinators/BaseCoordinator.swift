import Foundation
import UIKit

class BaseCoordinator: NSObject,
                       UINavigationControllerDelegate,
                       UIAdaptivePresentationControllerDelegate {
    private(set) var childCoordinators: [BaseCoordinator] = []
    private var parentCoordinator: BaseCoordinator?
    private var stackedViewControllers: NSHashTable<UIViewController> = .weakObjects()
    private(set) var root: UINavigationController

    init(navigationController: UINavigationController) {
        self.root = navigationController
        super.init()
        navigationController.presentationController?.delegate = self
    }

    final func start() {
        start(url: nil)
    }

    func start(url: URL?) {
        assertionFailure("This needs overriding")
    }

    func start(_ coordinator: BaseCoordinator) {
        start(coordinator, url: nil)
    }

    func start(_ coordinator: BaseCoordinator,
               url: URL?) {
        childCoordinators.append(coordinator)
        coordinator.root.delegate = coordinator
        coordinator.parentCoordinator = self
        coordinator.start(url: url)
    }

    func present(_ coordinator: BaseCoordinator,
                 animated: Bool = true) {
        start(coordinator)
        root.present(coordinator.root, animated: animated)
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
        guard let index = childCoordinators.firstIndex(of: child)
        else { return }
        childCoordinators.remove(at: index)
    }

    func dismiss(animated: Bool) {
        if root.presentingViewController != nil {
            root.dismiss(animated: animated)
        } else {
            root.popViewController(animated: animated)
        }
    }
}
