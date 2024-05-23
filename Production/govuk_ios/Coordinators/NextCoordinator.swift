import UIKit
import Foundation

class NextCoordinator: BaseCoordinator {
    private let title: String

    init(title: String,
         navigationController: UINavigationController) {
        self.title = title
        super.init(navigationController: navigationController)
    }

    override func start() {
        pushNext()
    }

    private var showNextAction: () -> Void {
        return { [weak self] in
            self?.pushNext()
        }
    }

    private func pushNext() {
        let viewController = TestViewController(
            color: .orange,
            tabTitle: "\(title) \(root.viewControllers.count)",
            nextAction: showNextAction,
            modalAction: { [weak self] in
                self?.root.popViewController(animated: true)
            }
        )
        push(viewController, animated: false)
    }

    deinit {
        print("Deinit \(title)")
    }
}
