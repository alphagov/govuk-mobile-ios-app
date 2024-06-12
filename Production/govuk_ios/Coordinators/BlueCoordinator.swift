import UIKit
import Foundation

class BlueCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let requestFocus: (UINavigationController) -> Void

    init(navigationController: UINavigationController,
         coordinatorBuilder: CoordinatorBuilder,
         requestFocus: @escaping (UINavigationController) -> Void) {
        self.requestFocus = requestFocus
        self.coordinatorBuilder = coordinatorBuilder
        super.init(navigationController: navigationController)
    }

    override func start(url: String?) {
        let viewModel = TestViewModel(
            color: .blue,
            tabTitle: "Blue",
            nextAction: showNextAction,
            modalAction: { }
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
            guard let self = self else { return }
            let coordinator = self.coordinatorBuilder.driving(
                navigationController: self.root
            )
            self.start(coordinator)
        }
    }

    private func handleDeepLink(url: String) {
        let deeplinkFactory = DeepLinkFactory(
            deepLinkStore: DrivingDeepLinkStore()
        )
        guard let deepLink = deeplinkFactory.fetchDeepLink(path: url)
        else { return }
        requestFocus(root)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            deepLink.action(parent: self)
        }
    }
}
