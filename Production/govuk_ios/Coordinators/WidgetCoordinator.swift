import Foundation
import UIKit

final class WidgetCoordinator: BaseCoordinator {
    public var viewController: UIViewController?

    public override func start(url: URL?) {
        guard let viewController else { return }
        push(viewController)
    }
}
