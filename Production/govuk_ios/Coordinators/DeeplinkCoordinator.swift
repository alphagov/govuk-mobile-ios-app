import Foundation

class DeeplinkCoordinator: BaseCoordinator {
    override func start(url: String?) {
        let viewController = TestViewController(
            color: .purple,
            tabTitle: "Deeplink",
            nextAction: { },
            modalAction: { }
        )
        push(viewController, animated: true)
    }
}
