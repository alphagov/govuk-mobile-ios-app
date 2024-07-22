import Foundation

struct SettingsDeeplinkRoute: DeeplinkRoute {
    private let coordinatorBuilder: CoordinatorBuilder

    init(coordinatorBuilder: CoordinatorBuilder) {
        self.coordinatorBuilder = coordinatorBuilder
    }

    var pattern: URLPattern {
        "/settings"
    }

    @MainActor
    func action(parent: BaseCoordinator,
                params: [String: String]) {
        let coordinator = self.coordinatorBuilder.settings
        parent.start(coordinator)
    }
}
