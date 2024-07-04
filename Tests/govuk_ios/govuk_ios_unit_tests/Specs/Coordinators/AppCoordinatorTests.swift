import UIKit
import Foundation
import XCTest

@testable import govuk_ios

class AppCoordinatorTests: XCTestCase {

    @MainActor
    func test_start_firstLaunch_startsLaunchCoordinator() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder()
        let mockNavigationController = UINavigationController()
        let mockLaunchCoodinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        mockCoodinatorBuilder._stubbedLaunchCoordinator = mockLaunchCoodinator

        let subject = AppCoordinator(
            coordinatorBuilder: mockCoodinatorBuilder,
            navigationController: mockNavigationController
        )

        subject.start()

        XCTAssertEqual(mockCoodinatorBuilder._receivedLaunchNavigationController, mockNavigationController)
        XCTAssertTrue(mockLaunchCoodinator._startCalled)
    }

    @MainActor
    func test_start_secondLaunch_startsTabCoordinator() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder()
        let mockNavigationController = UINavigationController()
        let mockLaunchCoodinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        let mockTabCoodinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        mockCoodinatorBuilder._stubbedLaunchCoordinator = mockLaunchCoodinator
        mockCoodinatorBuilder._stubbedTabCoordinator = mockTabCoodinator

        let subject = AppCoordinator(
            coordinatorBuilder: mockCoodinatorBuilder,
            navigationController: mockNavigationController
        )

        //First launch
        subject.start()

        XCTAssertTrue(mockLaunchCoodinator._startCalled)

        //Finish launch loading
        mockCoodinatorBuilder._receivedLaunchCompletion?()

        XCTAssertTrue(mockTabCoodinator._startCalled)

        //Reset values for second launch
        mockLaunchCoodinator._startCalled = false
        mockTabCoodinator._startCalled = false

        //Second launch
        subject.start()

        XCTAssertFalse(mockLaunchCoodinator._startCalled)
        XCTAssertTrue(mockTabCoodinator._startCalled)
    }

}
