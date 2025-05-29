import Foundation
import UIKit
import Factory

class SceneDelegate: UIResponder,
                     UIWindowSceneDelegate {
    @Inject(\.inactivityService) private var inactivityService: InactivityServiceInterface

    var window: UIWindow?

    private lazy var navigationController: UINavigationController = {
        let controller = UINavigationController()
        controller.setNavigationBarHidden(true, animated: false)
        controller.navigationBar.prefersLargeTitles = true
        return controller
    }()

    private lazy var coordinatorBuilder = CoordinatorBuilder(container: .shared)

    private lazy var coordinator = coordinatorBuilder.app(
        navigationController: navigationController,
        inactivityService: inactivityService
    )

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene)
        else { return }
        window = GovUIWindow(windowScene: windowScene, inactivityService: inactivityService)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        let url = connectionOptions.urlContexts.first?.url
        coordinator.start(url: url)
//        let notificationService = Container.shared.notificationService.resolve()
//        notificationService.addClickListener { deeplink in self.coordinator.start(url: deeplink) }
    }

    func scene(_ scene: UIScene,
               openURLContexts urlContexts: Set<UIOpenURLContext>) {
        guard let path = urlContexts.first?.url
        else { return }
        coordinator.start(url: path)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        coordinator.start(url: nil)
    }
}
