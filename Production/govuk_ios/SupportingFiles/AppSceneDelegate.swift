import UIKit

class AppSceneDelegate: UIResponder,
                        UIWindowSceneDelegate {
    var window: UIWindow?

    private var coordinator: AppCoordinator?
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
        loadAppCoordinator()
    }

    private func loadAppCoordinator() {
        coordinator = AppCoordinator(
            coordinatorBuilder: .init(),
            navigationController: navigationController
        )
        coordinator?.start(url: "/test")
    }
}
