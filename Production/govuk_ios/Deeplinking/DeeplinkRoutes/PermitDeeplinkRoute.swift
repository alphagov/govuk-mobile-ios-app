import Foundation
import UIKit

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
