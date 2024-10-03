import Foundation
import XCTest

@testable import govuk_ios

@MainActor
class BaseCoordinatorTestsXC: XCTestCase {
    func test_init_setsPresentationController() {
        let navigationController = UINavigationController()
        let subject = BaseCoordinator(navigationController: navigationController)

        XCTAssert(navigationController.presentationController?.delegate === subject)
    }

    func test_presentationControllerDidDismiss_callsFinish() {
        let navigationController = UINavigationController()
        let subject = TestCoordinator(navigationController: navigationController)
        let parentCoordinator = MockBaseCoordinator()
        parentCoordinator.start(subject)

        let expectation = expectation()
        parentCoordinator._childDidFinishHandler = { child in
            XCTAssertEqual(child, subject)
            expectation.fulfill()
        }

        let presentationController = UIPresentationController(
            presentedViewController: .init(),
            presenting: .init()
        )
        subject.presentationControllerDidDismiss(presentationController)
        wait(for: [expectation])
    }

    func test_push_addsViewControllerToStack() {
        let navigationController = UINavigationController()
        let subject = TestCoordinator(navigationController: navigationController)

        let viewController1 = UIViewController()
        navigationController.viewControllers = [viewController1]

        let viewController2 = UIViewController()

        subject.push(viewController2, animated: false)

        XCTAssert(navigationController.viewControllers.contains(viewController1))
        XCTAssert(navigationController.viewControllers.contains(viewController2))
    }

    func test_setViewController_addsViewControllerToStack() {
        let navigationController = UINavigationController()
        let subject = TestCoordinator(navigationController: navigationController)

        let viewController1 = UIViewController()
        navigationController.viewControllers = [viewController1]

        let viewController2 = UIViewController()
        subject.set(viewController2, animated: false)

        XCTAssertFalse(navigationController.viewControllers.contains(viewController1))
        XCTAssert(navigationController.viewControllers.contains(viewController2))
    }

    func test_setViewControllers_addsViewControllerToStack() {
        let navigationController = UINavigationController()
        let subject = TestCoordinator(navigationController: navigationController)

        let viewController1 = UIViewController()
        navigationController.viewControllers = [viewController1]

        let viewController2 = UIViewController()
        let viewController3 = UIViewController()
        subject.set(
            [
                viewController2,
                viewController3
            ],
            animated: false
        )

        XCTAssertEqual(navigationController.viewControllers.count, 2)
    }

//    func test_viewControllerPopped_remainingViewControllers_doesNothing() {
//        let navigationController = UINavigationController()
//        let subject = TestCoordinator(navigationController: navigationController)
//
//        let parentCoordinator = MockBaseCoordinator()
//        parentCoordinator.start(subject)
//
//        subject.push(UIViewController(), animated: false)
//        subject.push(UIViewController(), animated: false)
//
//        let expectation = expectation()
//        var completionCalled = false
//        parentCoordinator._childDidFinishHandler = { child in
//            completionCalled = true
//        }
//
//        navigationController.popViewController(animated: false)
//
//        expectation.fulfillAfter(0.2)
//        waitForExpectations(
//            timeout: 0.5,
//            handler: { _ in
//                Task { @MainActor in
//                    XCTAssertFalse(completionCalled)
//                }
//            }
//        )
//    }

    func test_viewControllerPopped_finalViewController_callsFinish() async {
        let parentCoordinator = MockBaseCoordinator()
        let navigationController = parentCoordinator.root
        let window = UIApplication.shared.windows.first!
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        //Requires TestCoordinator to prevent crash when calling start()
        let subject = TestCoordinator(navigationController: navigationController)
        parentCoordinator.start(subject)

        navigationController.pushViewController(UIViewController(), animated: false)

        subject.push(UIViewController(), animated: false)

        await withCheckedContinuation { @MainActor continuation in
            parentCoordinator._childDidFinishHandler = { @MainActor child in
                continuation.resume()
            }
            navigationController.popViewController(animated: false)
        }
    }

    func test_startCoordinator_startsCoordinator() {
        let navigationController = UINavigationController()
        let child = MockBaseCoordinator(navigationController: navigationController)
        let subject = TestCoordinator(navigationController: navigationController)

        subject.start(child)

        XCTAssertTrue(child._startCalled)
    }

    func test_presentCoordinator_startsCoordinator() {
        let childNavigationController = UINavigationController()
        let child = MockBaseCoordinator(navigationController: childNavigationController)

        let navigationController = MockNavigationController()
        let subject = TestCoordinator(navigationController: navigationController)

        subject.present(
            child,
            animated: false
        )
        XCTAssertTrue(child._startCalled)
        XCTAssertEqual(navigationController._presentedViewController, childNavigationController)
    }

    func test_dismiss_modal_callsDismiss() {
        let mockNavigationController = MockNavigationController()
        let subject = TestCoordinator(navigationController: mockNavigationController)

        let parentNavigationController = UINavigationController()
        let parent = MockBaseCoordinator(navigationController: parentNavigationController)
        parent.present(subject, animated: false)

        mockNavigationController._stubbedPresentingViewController = parentNavigationController

        subject.dismiss(animated: false)

        XCTAssert(mockNavigationController._dismissCalled)
    }

    func test_dismiss_pushed_callsPop() {
        let mockNavigationController = MockNavigationController()
        let subject = TestCoordinator(navigationController: mockNavigationController)

        let parent = MockBaseCoordinator(navigationController: mockNavigationController)
        parent.start(subject)

        subject.dismiss(animated: false)

        XCTAssert(mockNavigationController._popCalled)
    }
}

private class TestCoordinator: BaseCoordinator {

    override func start(url: URL?) { }

}
