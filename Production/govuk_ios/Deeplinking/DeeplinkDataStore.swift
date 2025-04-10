import Foundation
import UIKit

typealias URLPattern = String

struct DeeplinkDataStore {
    let routes: [DeeplinkRoute]
    let viewControllerBuilder: ViewControllerBuilder
    let root: UIViewController

    func route(for url: URL,
               parent: BaseCoordinator) -> ResolvedDeeplinkRoute? {
        guard isValidDeeplink(url: url)
        else { return nil }

        return routes
            .lazy
            .map {
                DeeplinkRoutingComponents(
                    sourceURL: url,
                    route: $0
                )
            }
            .first { $0.hasMatchingUrls() }
            .map {
                .init(
                    components: $0,
                    parent: parent
                )
            }
    }

    private func isValidDeeplink(url: URL) -> Bool {
        !url.isFileURL &&
        !url.pathComponents.isEmpty
    }

    @MainActor
    func presentDeeplinkPage(for url: URL) {
        let modalViewController = viewControllerBuilder.webViewController(for: url)
        let navigationController = UINavigationController(rootViewController: modalViewController)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.formSheet
        root.present(navigationController, animated: true)
    }
}
