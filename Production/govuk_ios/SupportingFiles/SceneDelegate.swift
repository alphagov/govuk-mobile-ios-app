import Foundation
import UIKit
import Factory
import GOVKit

class SceneDelegate: UIResponder,
                     UIWindowSceneDelegate {
    @Inject(\.inactivityService) private var inactivityService: InactivityServiceInterface
    @Inject(\.analyticsService) private var analyticsService: AnalyticsServiceInterface

    var window: UIWindow?

    private lazy var navigationController: UINavigationController = {
        let controller = UINavigationController()
        controller.setNavigationBarHidden(true, animated: false)
        controller.navigationBar.prefersLargeTitles = true
        return controller
    }()

    private lazy var coordinatorBuilder = CoordinatorBuilder(container: .shared)

    private lazy var appCoordinator = coordinatorBuilder.app(
        navigationController: navigationController,
        inactivityService: inactivityService
    )

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene)
        else { return }
        window = GovUIWindow(
            windowScene: windowScene,
            inactivityService: inactivityService
        )
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        let url = connectionOptions.urlContexts.first?.url
        appCoordinator.start(url: url)
        let notificationService = Container.shared.notificationService.resolve()
        notificationService.addClickListener { [weak self] deeplink in
            self?.appCoordinator.start(url: deeplink)
        }
    }

    func scene(_ scene: UIScene,
               openURLContexts urlContexts: Set<UIOpenURLContext>) {
        guard let path = urlContexts.first?.url
        else { return }
        appCoordinator.start(url: path)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        appCoordinator.start(url: nil)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        appCoordinator.showPrivacyScreen(appDidTimeout: false)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        appCoordinator.hidePrivacyScreen()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        let appBackgrounded = "App Backgrounded"
        let appEvent = AppEvent.function(
            text: appBackgrounded,
            type: "AppBackgrounded",
            section: appBackgrounded,
            action: appBackgrounded
        )
        analyticsService.track(event: appEvent)
    }
}
