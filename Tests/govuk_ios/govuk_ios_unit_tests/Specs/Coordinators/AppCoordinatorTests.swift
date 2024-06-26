import UIKit
import Foundation
import XCTest

@testable import govuk_ios

class AppCoordinatorTests: XCTestCase {

    @MainActor
    func test_start_startsLanuchCoordinator() {
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

}
