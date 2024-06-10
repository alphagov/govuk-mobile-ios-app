import UIKit
import Foundation

class BlueCoordinator: BaseCoordinator {
    private let requestFocus: (UINavigationController) -> Void

    init(navigationController: UINavigationController,
         requestFocus: @escaping (UINavigationController) -> Void) {
        self.requestFocus = requestFocus
        super.init(navigationController: navigationController)
    }

    override func start(url: String?) {
        let viewController = TestViewController(
            color: .blue,
            tabTitle: "Blue",
            nextAction: showNextAction,
            modalAction: { }
        )
        set([viewController], animated: false)

        guard let url = url else { return }
        handleDeepLink(url: url)
    }

    private var showNextAction: () -> Void {
        return { [weak self] in
            guard let strongSelf = self else { return }
            let coordinator = DrivingCoordinator(
                navigationController: strongSelf.root
            )
            strongSelf.start(coordinator)
        }
    }

    private func handleDeepLink(url: String) {
        let deeplinkFactory = DeepLinkFactory(
            deepLinkStore: DrivingDeepLinkStore()
        )
        guard let deepLink = deeplinkFactory.fetchDeepLink(path: url)
        else { return }
        requestFocus(root)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [unowned self] in
            deepLink.action(parent: self)
        }
    }
}
