import Foundation

struct DrivingDeeplinkRoute: DeeplinkRoute {
    private let coordinatorBuilder: CoordinatorBuilder

    init(coordinatorBuilder: CoordinatorBuilder) {
        self.coordinatorBuilder = coordinatorBuilder
    }

    var pattern: URLPattern {
        "/driving"
    }

    @MainActor
    func action(parent: BaseCoordinator,
                params: [String: String]) {
        let coordinator = self.coordinatorBuilder.driving(
            navigationController: parent.root
        )
        parent.start(coordinator)
    }
}
