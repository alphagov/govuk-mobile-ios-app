import Foundation

struct HomeDeeplinkRoute: DeeplinkRoute {
    private let coordinatorBuilder: CoordinatorBuilder

    init(coordinatorBuilder: CoordinatorBuilder) {
        self.coordinatorBuilder = coordinatorBuilder
    }

    var pattern: URLPattern {
        "/home"
    }

    @MainActor
    func action(parent: BaseCoordinator, params: [String: String]) {}
}
