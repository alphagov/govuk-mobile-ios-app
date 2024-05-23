import Foundation
import XCTest

import Coordination

@testable import govuk_ios

class BaseCoordinatorTests: XCTestCase {

    var subject: BaseCoordinator?

    override class func setUp() {
        super.setUp()
        UIView.setAnimationsEnabled(false)
    }

    @MainActor
    func test_init_setsPresentationController() {
        let navigationController = UINavigationController()
        let subject = BaseCoordinator(navigationController: navigationController)

        XCTAssert(navigationController.presentationController?.delegate === subject)
    }

    @MainActor
    func test_presentationControllerDidDismiss_callsFinish() {
        let navigationController = UINavigationController()
        let subject = BaseCoordinator(navigationController: navigationController)
        let parentCoordinator = MockParentCoordinator()
        subject.parentCoordinator = parentCoordinator

        let expectation = expectation(description: "regain handler")
        parentCoordinator.didRegainHandler = { child in
            XCTAssertEqual(child as? BaseCoordinator, subject)
            expectation.fulfill()
        }

        let presentationController = UIPresentationController(
            presentedViewController: .init(),
            presenting: .init()
        )
        subject.presentationControllerDidDismiss(presentationController)
        wait(for: [expectation])
    }

    @MainActor
    func test_push_addsViewControllerToStack() {
        let navigationController = UINavigationController()
        let subject = BaseCoordinator(navigationController: navigationController)

        let viewController1 = UIViewController()
        navigationController.viewControllers = [viewController1]

        let viewController2 = UIViewController()

        subject.push(viewController2, animated: false)

        XCTAssert(navigationController.viewControllers.contains(viewController1))
        XCTAssert(navigationController.viewControllers.contains(viewController2))
    }

    @MainActor
    func test_setViewController_addsViewControllerToStack() {
        let navigationController = UINavigationController()
        let subject = BaseCoordinator(navigationController: navigationController)

        let viewController1 = UIViewController()
        navigationController.viewControllers = [viewController1]

        let viewController2 = UIViewController()
        subject.set(viewController2, animated: false)

        XCTAssertFalse(navigationController.viewControllers.contains(viewController1))
        XCTAssert(navigationController.viewControllers.contains(viewController2))
    }

    @MainActor
    func test_setViewControllers_addsViewControllerToStack() {
        let navigationController = UINavigationController()
        let subject = BaseCoordinator(navigationController: navigationController)

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

    @MainActor
    func test_viewControllerPopped_remainingViewControllers_doesNothing() {
        let navigationController = UINavigationController()
        let subject = BaseCoordinator(navigationController: navigationController)

        let parentCoordinator = MockParentCoordinator()
        subject.parentCoordinator = parentCoordinator

        subject.push(UIViewController(), animated: false)
        subject.push(UIViewController(), animated: false)

        let expectation = expectation(description: "regain handler 2")
        expectation.isInverted = true
        parentCoordinator.didRegainHandler = { child in
            expectation.fulfill()
        }

        navigationController.popViewController(animated: false)

        wait(for: [expectation], timeout: 1)
    }

    @MainActor
    func test_viewControllerPopped_finalViewController_callsFinish() {
        let parentCoordinator = MockParentCoordinator()
        let navigationController = parentCoordinator.root
        let window = UIApplication.shared.windows.first!
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        //Requires TestCoordinator to prevent crash when calling start()
        let subject = TestCoordinator(navigationController: navigationController)
        parentCoordinator.openChildInline(subject)

        navigationController.pushViewController(UIViewController(), animated: false)

        subject.push(UIViewController(), animated: false)

        let expectation = expectation(description: "regain handler 3")
        parentCoordinator.didRegainHandler = { child in
            expectation.fulfill()
        }

        navigationController.popViewController(animated: false)

        wait(for: [expectation], timeout: 1)
    }

    @MainActor
    func test_startCoordinator_startsCoordinator() {
        let navigationController = UINavigationController()
        let child = TestCoordinator(navigationController: navigationController)
        let subject = TestCoordinator(navigationController: navigationController)

        subject.start(child)

        XCTAssertTrue(child._startCalled)
    }

    @MainActor
    func test_presentCoordinator_startsCoordinator() {
        let childNavigationController = UINavigationController()
        let child = TestCoordinator(navigationController: childNavigationController)

        let navigationController = MockNavigationController()
        let subject = TestCoordinator(navigationController: navigationController)

        subject.present(
            child,
            animated: false
        )

        XCTAssertTrue(child._startCalled)
        XCTAssertEqual(navigationController._presentedViewController, childNavigationController)
    }

}

private class TestCoordinator: BaseCoordinator {

    var _startCalled: Bool = false

    override func start() {
        _startCalled = true
    }

}
