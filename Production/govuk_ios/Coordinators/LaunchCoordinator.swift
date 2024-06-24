import UIKit
import Foundation

class LaunchCoordinator: BaseCoordinator {
    private let completion: () -> Void

    init(navigationController: UINavigationController,
         completion: @escaping () -> Void) {
        self.completion = completion
        super.init(navigationController: navigationController)
    }

    override func start() {
        let viewController = LaunchViewController()
        set(viewController, animated: false)
        sendCompletion()
    }

    private func sendCompletion() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.completion()
        }
    }
}
