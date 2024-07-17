import Foundation
import UIKit

class AppSceneDelegate: UIResponder,
                        UIWindowSceneDelegate {
    var window: UIWindow?

    private lazy var navigationController: UINavigationController = {
        let controller = UINavigationController()
        controller.setNavigationBarHidden(true, animated: false)
        return controller
    }()
    private lazy var coordinatorBuilder = CoordinatorBuilder()
    private lazy var coordinator: BaseCoordinator? = coordinatorBuilder.app(
        navigationController: navigationController
    )

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene)
        else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        let url = connectionOptions.urlContexts.first?.url
        coordinator?.start(url: url)
    }

    func scene(_ scene: UIScene,
               openURLContexts urlContexts: Set<UIOpenURLContext>) {
        guard let path = urlContexts.first?.url
        else { return }
        coordinator?.start(url: path)
    }
}
