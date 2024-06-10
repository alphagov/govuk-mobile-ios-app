import UIKit
import Foundation

class AppCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let deeplinkService: DeeplinkServiceInterface

    init(coordinatorBuilder: CoordinatorBuilder,
         navigationController: UINavigationController,
         deeplinkService: DeeplinkServiceInterface) {
        self.coordinatorBuilder = coordinatorBuilder
        self.deeplinkService = deeplinkService
        super.init(navigationController: navigationController)
    }

    override func start() {
        startLaunch()
    }

    private func startLaunch() {
        let coordinator = coordinatorBuilder.launch(
            navigationController: root,
            completion: { [weak self] in
                self?.showTabs()
            }
        )
        start(coordinator)
    }

    private func showTabs() {
        let coordinator = coordinatorBuilder.tab(
            navigationController: root
        )
        start(coordinator)
    }

    func test() {
        test2()
    }

    func test2() {
        test3()
    }

    func test3() {
        print("test")
    }

    func test4() {
        print("test")
    }

    func test5() {
        print("test")
    }

    func test6() {
        print("test")
    }

    func test7() {
        print("test")
    }

    func test8() {
        print("test")
    }

    func test9() {
        print("test")
    }

    func test10() {
        print("test")
    }
}
