import Foundation
import UIKit

protocol DeeplinkRoute {
    var pattern: URLPattern { get }
    func action(parent: BaseCoordinator,
                params: [String: String])
}

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

struct PermitDeeplinkRoute: DeeplinkRoute {
    private let coordinatorBuilder: CoordinatorBuilder

    init(coordinatorBuilder: CoordinatorBuilder) {
        self.coordinatorBuilder = coordinatorBuilder
    }

    var pattern: URLPattern {
        "/driving/permit/:permit_id"
    }

    @MainActor
    func action(parent: BaseCoordinator,
                params: [String: String]) {
        guard let permitId = params["permit_id"]
        else { return }
        let navigationController = UINavigationController()
        let coordinator = self.coordinatorBuilder.permit(
            permitId: permitId,
            navigationController: navigationController
        )
        parent.present(coordinator)
    }
}
