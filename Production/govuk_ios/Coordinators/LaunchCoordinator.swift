import UIKit
import Foundation

class LaunchCoordinator: BaseCoordinator {
    private let completion: (String?) -> Void

    init(navigationController: UINavigationController,
         completion: @escaping (String?) -> Void) {
        self.completion = completion
        super.init(navigationController: navigationController)
    }

    override func start(url: String?) {
        let viewController = LaunchViewController()
        set(viewController, animated: false)
        sendCompletion(url: url)
    }

    private func sendCompletion(url: String?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.completion(url)
        }
    }
}
