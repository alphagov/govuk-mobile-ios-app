import UIKit
import Foundation

class ColorCoordinator: BaseCoordinator {
    private let color: UIColor
    private let title: String

    init(navigationController: UINavigationController,
         color: UIColor,
         title: String) {
        self.color = color
        self.title = title
        super.init(navigationController: navigationController)
    }

    override func start() {
        let viewController = ViewController(
            color: color,
            tabTitle: title,
            nextAction: showNextAction,
            modalAction: showModalAction
        )
        set([viewController], animated: false)
    }

    private var showNextAction: () -> Void {
        return { [weak self] in
            guard let strongSelf = self else { return }
            let coordinator = NextCoordinator(
                title: "Next",
                navigationController: strongSelf.root
            )
            strongSelf.push(coordinator)
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

    deinit {
        print("Deinit \(title)")
    }
}
