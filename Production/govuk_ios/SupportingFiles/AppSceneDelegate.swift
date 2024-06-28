import UIKit

class AppSceneDelegate: UIResponder,
                        UIWindowSceneDelegate {
    var window: UIWindow?

    private lazy var navigationController: UINavigationController = {
        let controller = UINavigationController()
        controller.setNavigationBarHidden(true, animated: false)
        return controller
    }()
    private lazy var coordinatorBuilder = CoordinatorBuilder(
        container: .shared
    )
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

        let path = connectionOptions.urlContexts.first?.url
//        print(path)

        coordinator?.start(url: path?.absoluteString)
    }

    func scene(_ scene: UIScene,
               openURLContexts urlContexts: Set<UIOpenURLContext>) {
        guard let path = urlContexts.first?.url
        else { return }

        var deeplink = DeepLink(url: path)

        dump(deeplink)
        print(deeplink.scheme)
        print(deeplink.path)
        print(deeplink.pathComponents)
        print(deeplink.queryItems)

        deeplink.queryItems.forEach {
            print($0.value)
        }
        // inject Deeplink
        coordinator?.start(url: path.absoluteString)
    }
}

struct DeepLink {
    let url: URL
    private var components: URLComponents?

    var path: String? {
        components?.path
    }

    var scheme: String? {
        components?.scheme
    }

    var pathComponents: [String] {
        NSURL(string: url.absoluteString)?.pathComponents
            .map {
            $0.filter { $0 != "/" }
        }
        ?? []
    }

    var queryItems: [URLQueryItem] {
        components?.queryItems ?? []
    }

    init(url: URL) {
        if let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            components = urlComponents
        }
        self.url = url
    }

    func perform() throws -> Result<DeepLinkRoute, DeepLinkError> {
        .success(DrivingDeepLink())
    }
}

enum DeepLinkError: Error {
    case noDeeplink
    case pathComponent
    case noValue
    case noMatchingPaths
}
