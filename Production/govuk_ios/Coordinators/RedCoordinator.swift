import UIKit
import Foundation

class RedCoordinator: BaseCoordinator {
    override func start(url: String?) {
        let viewModel = TestViewModel(
            color: .red,
            tabTitle: "Red",
            nextAction: showNextAction,
            modalAction: showModalAction
        )
        let viewController = TestViewController(
            viewModel: viewModel
        )
        set([viewController], animated: false)

        guard let url = url else { return }
        handleDeepLink(url: url)
    }

    private var showNextAction: () -> Void {
        return { [weak self] in
            guard let strongSelf = self else { return }
            let coordinator = NextCoordinator(
                title: "Next",
                navigationController: strongSelf.root
            )
            strongSelf.start(coordinator)
        }
    }

    private var showModalAction: () -> Void {
        return { [weak self] in
            guard let strongSelf = self else { return }
            let navigationController = UINavigationController()
            let coordinator = NextCoordinator(
                title: "Modal",
                navigationController: navigationController
            )
            strongSelf.present(coordinator)
        }
    }

    private func handleDeepLink(url: String) {
        let deeplinkFactory = DeepLinkFactory(
            deepLinkStore: TestDeepLinkStore()
        )
        let deepLink = deeplinkFactory.fetchDeepLink(path: url)
        deepLink?.action(parent: self)
    }
}
