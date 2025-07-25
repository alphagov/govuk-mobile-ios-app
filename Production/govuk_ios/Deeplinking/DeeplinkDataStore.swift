import Foundation
import UIKit

typealias URLPattern = String

struct DeeplinkDataStore {
    let routes: [DeeplinkRoute]
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
}
