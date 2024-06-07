import UIKit
import Foundation

class LaunchCoordinator: BaseCoordinator {
    private let completion: (String?) -> Void
    private let deepLinkPaths: [String]

    init(navigationController: UINavigationController,
         completion: @escaping (String?) -> Void, paths: [String]) {
        self.completion = completion
        self.deepLinkPaths = paths
        super.init(navigationController: navigationController)
    }

    override func start() {
        let viewController = LaunchViewController()
        set(viewController, animated: false)
        let defaults = UserDefaults()
        handleDeepLink(url: defaults.deepLinkPath)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.completion(defaults.deepLinkPath)
        }
        }

    private func canHandleLinks(path: String?) {
        if deepLinkPaths.contains(where: {$0 == path}) {
            handleDeepLink(url: path)
        }
    }

    override func handleDeepLink(url: String?) { }
}
