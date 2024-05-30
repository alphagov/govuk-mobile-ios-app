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
        let viewModel = TestViewModel(
            color: .orange,
            tabTitle: "\(title) \(root.viewControllers.count)",
            nextAction: showNextAction,
            modalAction: { [weak self] in
                self?.root.popViewController(animated: true)
            }
        )
        let viewController = TestViewController(
            viewModel: viewModel
        )
        push(viewController, animated: false)
    }
}
