import UIKit
import Foundation

class MockNavigationController: UINavigationController {

    var _stubbedPresentingViewController: UIViewController?
    override var presentingViewController: UIViewController? {
        _stubbedPresentingViewController ?? super.presentingViewController
    }

    private(set) var _presentedViewController: UIViewController?
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        super.present(
            viewControllerToPresent,
            animated: flag,
            completion: completion
        )
        _presentedViewController = viewControllerToPresent
    }

    var _dismissCalled: Bool = false
    var _receivedDismissAnimated: Bool?
    var _receivedDismissCompletion: (() -> Void)?
    override func dismiss(animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        _receivedDismissAnimated = flag
        _receivedDismissCompletion = completion
        _dismissCalled = true
    }

    var _popCalled: Bool = false
    override func popViewController(animated: Bool) -> UIViewController? {
        _popCalled = true
        return super.popViewController(animated: animated)
    }

    var _popToRootCalled: Bool = false
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        _popToRootCalled = true
        return []
    }

    var _pushedViewController: UIViewController?
    override func pushViewController(_ viewController: UIViewController, 
                                     animated: Bool) {
        _pushedViewController = viewController
        super.pushViewController(viewController, animated: animated)
    }

    var _setViewControllers: [UIViewController]?
    override func setViewControllers(_ viewControllers: [UIViewController], 
                                     animated: Bool) {
        _setViewControllers = viewControllers
        super.setViewControllers(viewControllers, animated: animated)
    }
}
