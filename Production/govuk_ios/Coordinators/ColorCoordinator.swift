import UIKit
import Foundation

class ColorCoordinator: BaseCoordinator{

    private let color: UIColor
    private let title: String
    private let deepLinkPaths: [String]
    private let nav:UINavigationController

    init(navigationController: UINavigationController,
         color: UIColor,
         title: String,deepLinkPaths:[String]) {
        self.color = color
        self.title = title
        self.deepLinkPaths = deepLinkPaths
        self.nav = navigationController
        super.init(navigationController: navigationController)
    }
    
    override func canHandleLinks(path: String) -> Bool {
        return deepLinkPaths.contains(where: {$0 == path}) ? true : false
    }

    override func start() {
        let viewController = TestViewController(
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
    
    override func handleDeepLink(url: String) {
       let deeplinkFactory = DeepLinkFactory(deepLinkStore: DeepLinkStore(),navigationController: nav)
       let deepLink = deeplinkFactory.fetchDeepLink(path: url)
       deepLink?.action()
   }
}

