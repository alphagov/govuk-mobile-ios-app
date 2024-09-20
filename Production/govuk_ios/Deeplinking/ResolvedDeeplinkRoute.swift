import Foundation

struct ResolvedDeeplinkRoute {
    let url: URL
    let parameters: [String: String]
    let parent: BaseCoordinator
    let route: DeeplinkRoute

    init(components: DeeplinkRoutingComponents,
         parent: BaseCoordinator) {
        self.url = components.sourceURL
        self.parameters = components.resolveParameters()
        self.route = components.route
        self.parent = parent
    }

    @MainActor
    func action() {
        route.action(
            parent: parent,
            params: parameters
        )
    }
}
