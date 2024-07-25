import Foundation
import XCTest

@testable import govuk_ios

class SettingsCoordinatorTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        UIView.setAnimationsEnabled(false)
    }

    @MainActor
    func test_start_setsSettingsViewController() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder(container: .init())
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedSettingsViewController = expectedViewController
        let navigationController = UINavigationController()
        let subject = SettingsCoordinator(
            navigationController: navigationController,
            coodinatorBuilder: mockCoodinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: [])
        )
        subject.start()

        XCTAssertEqual(navigationController.viewControllers.first, expectedViewController)
    }
}
