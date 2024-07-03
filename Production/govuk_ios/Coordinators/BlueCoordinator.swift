import UIKit
import Foundation

class BlueCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let requestFocus: (UINavigationController) -> Void
    private let deeplinkStore: DeeplinkDataStore

    init(navigationController: UINavigationController,
         coordinatorBuilder: CoordinatorBuilder,
         deeplinkStore: DeeplinkDataStore,
         requestFocus: @escaping (UINavigationController) -> Void) {
        self.coordinatorBuilder = coordinatorBuilder
        self.requestFocus = requestFocus
        self.deeplinkStore = deeplinkStore
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewModel = TestViewModel(
            color: .blue,
            tabTitle: "Blue",
            primaryTitle: "Next",
            primaryAction: showNextAction,
            secondaryTitle: nil,
            secondaryAction: nil
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

    private func handleDeepLink(url: URL) {
        guard let deepLink = deeplinkStore.route(for: url)
        else { return }
        requestFocus(root)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            deepLink.action(parent: self)
        }
    }
}
