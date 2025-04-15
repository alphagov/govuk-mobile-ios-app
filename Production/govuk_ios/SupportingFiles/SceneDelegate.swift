import Foundation
import UIKit

class SceneDelegate: UIResponder,
                     UIWindowSceneDelegate {
    var window: UIWindow?
    @Inject(\.notificationService) private var notificationService: NotificationServiceInterface

    private lazy var navigationController: UINavigationController = {
        let controller = UINavigationController()
        controller.setNavigationBarHidden(true, animated: false)
        controller.navigationBar.prefersLargeTitles = true
        return controller
    }()

    private lazy var coordinatorBuilder = CoordinatorBuilder(container: .shared)

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
        notificationService.addClickListener { deeplink in
            self.coordinator?.start(url: deeplink)
        }
    }

    func scene(_ scene: UIScene,
               openURLContexts urlContexts: Set<UIOpenURLContext>) {
        guard let path = urlContexts.first?.url
        else { return }
        coordinator?.start(url: path)
    }
}
