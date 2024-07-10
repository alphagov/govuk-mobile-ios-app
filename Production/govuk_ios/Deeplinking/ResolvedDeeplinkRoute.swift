import Foundation

struct ResolvedDeeplinkRoute {
    let url: URL
    let parameters: [String: String]
    let route: DeeplinkRoute

    init(components: DeeplinkRoutingComponents) {
        self.url = components.sourceURL
        self.parameters = components.resolveParameters()
        self.route = components.route
    }

    func action(parent: BaseCoordinator) {
        route.action(
            parent: parent,
            params: parameters
        )
    }
}
