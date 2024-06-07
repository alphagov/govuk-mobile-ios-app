import Foundation
import UIKit

class BaseCoordinator: NSObject,
                       UINavigationControllerDelegate,
                       UIAdaptivePresentationControllerDelegate {
    private var childCoordinators: [BaseCoordinator] = []
    private var parentCoordinator: BaseCoordinator?
    private var stackedViewControllers: NSHashTable<UIViewController> = .weakObjects()
    private(set) var root: UINavigationController

    init(navigationController: UINavigationController) {
        self.root = navigationController
        super.init()
        navigationController.presentationController?.delegate = self
    }

    func start(url: String?) {
        assertionFailure("This needs overriding")
    }

    func canHandleLink(path: String) -> Bool {
        return false
    }

    func start(_ coordinator: BaseCoordinator,
               url: String? = nil) {
        childCoordinators.append(coordinator)
        coordinator.root.delegate = coordinator
        coordinator.parentCoordinator = self
        coordinator.start(url: url)
    }

    func present(_ coordinator: BaseCoordinator,
                 url: String? = nil,
                 animated: Bool = true) {
        start(coordinator, url: url)
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
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
            childCoordinators.remove(at: index)
            break
        }
    }
}
