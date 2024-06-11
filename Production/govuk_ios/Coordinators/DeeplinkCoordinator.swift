import Foundation

class DeeplinkCoordinator: BaseCoordinator {
    override func start(url: String?) {
        let viewModel = TestViewModel(
            color: .purple,
            tabTitle: "Deeplink",
            nextAction: { },
            modalAction: { }
        )
        let viewController = TestViewController(
            viewModel: viewModel
        )
        push(viewController, animated: true)
    }
}
