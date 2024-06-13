import UIKit
import Foundation
import XCTest

@testable import govuk_ios

class AppCoordinatorTests: XCTestCase {

    @MainActor
    func test_start_startsLanuchCoordinator() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder(
            container: .init()
        )
        let mockNavigationController = UINavigationController()
        let mockLaunchCoodinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        mockCoodinatorBuilder._stubbedLaunchCoordinator = mockLaunchCoodinator

        let subject = AppCoordinator(
            coordinatorBuilder: mockCoodinatorBuilder,
            navigationController: mockNavigationController,
            deeplinkService: MockDeeplinkService()
        )

        subject.start()

        XCTAssertEqual(mockCoodinatorBuilder._receivedLaunchNavigationController, mockNavigationController)
        XCTAssertTrue(mockLaunchCoodinator._startCalled)
    }

    @MainActor
    func test_the_tests() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder(
            container: .init()
        )
        let subject = AppCoordinator(
            coordinatorBuilder: mockCoodinatorBuilder,
            navigationController: UINavigationController(),
            deeplinkService: MockDeeplinkService()
        )

        XCTAssertNoThrow(subject.test())
        XCTAssertNoThrow(subject.test2())
        XCTAssertNoThrow(subject.test3())
        XCTAssertNoThrow(subject.test4())
        XCTAssertNoThrow(subject.test5())
        XCTAssertNoThrow(subject.test6())
        XCTAssertNoThrow(subject.test7())
        XCTAssertNoThrow(subject.test8())
        XCTAssertNoThrow(subject.test9())
        XCTAssertNoThrow(subject.test10())
    }

}
