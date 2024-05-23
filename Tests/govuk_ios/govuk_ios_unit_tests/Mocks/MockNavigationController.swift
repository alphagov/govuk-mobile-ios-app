import UIKit
import Foundation

class MockNavigationController: UINavigationController {

    private(set) var _presentedViewController: UIViewController?
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag, completion: completion)
        _presentedViewController = viewControllerToPresent
    }

}
