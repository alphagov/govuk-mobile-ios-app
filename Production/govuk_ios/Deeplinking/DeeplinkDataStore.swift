import Foundation

typealias URLPattern = String

struct DeeplinkDataStore {
    private let routes: [DeeplinkRoute]

    init(routes: [DeeplinkRoute]) {
        self.routes = routes
    }

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
