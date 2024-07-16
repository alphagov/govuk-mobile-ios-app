import UIKit

class AppSceneDelegate: UIResponder,
                        UIWindowSceneDelegate {
    var window: UIWindow?

    private lazy var navigationController: UINavigationController = {
        let controller = UINavigationController()
        controller.setNavigationBarHidden(true, animated: false)
        return controller
    }()

    private lazy var userDefaults: UserDefaults = {
        let userDefaults = UserDefaults.standard
        return userDefaults
    }()
    private lazy var coordinatorBuilder = CoordinatorBuilder(
        container: .shared
    )
    private lazy var coordinator: BaseCoordinator? = coordinatorBuilder.app(
        navigationController: navigationController, userDefaults: userDefaults
    )

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene)
        else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        coordinator?.start()
    }
}
