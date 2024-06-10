import UIKit

class AppSceneDelegate: UIResponder,
                        UIWindowSceneDelegate {
    var window: UIWindow?

    private lazy var coordinator: AppCoordinator? = AppCoordinator(
        coordinatorBuilder: .init(),
        navigationController: navigationController
    )
    private lazy var navigationController: UINavigationController = {
        let controller = UINavigationController()
        controller.setNavigationBarHidden(true, animated: false)
        return controller
    }()

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene)
        else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        coordinator?.start(url: "/driving")
//        coordinator?.start(url: "/driving/permit/123")
//        coordinator?.start(url: nil)
    }
}
