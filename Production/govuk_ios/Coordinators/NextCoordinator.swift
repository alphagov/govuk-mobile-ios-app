import UIKit
import Foundation

class NextCoordinator: BaseCoordinator {
    private let title: String

    init(title: String,
         navigationController: UINavigationController) {
        self.title = title
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
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
            primaryTitle: "Next",
            primaryAction: showNextAction,
            secondaryTitle: root.viewControllers.isEmpty ? nil : "Pop",
            secondaryAction: { [weak self] in
                self?.root.popViewController(animated: true)
            }
        )
        let viewController = TestViewController(
            viewModel: viewModel
        )
        push(viewController, animated: true)
    }
}
