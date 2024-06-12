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
        super.present(viewControllerToPresent, animated: flag, completion: completion)
        _presentedViewController = viewControllerToPresent
    }

    var _dismissCalled: Bool = false
    override func dismiss(animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        _dismissCalled = true
    }

    var _popCalled: Bool = false
    override func popViewController(animated: Bool) -> UIViewController? {
        _popCalled = true
        return super.popViewController(animated: animated)
    }
}
