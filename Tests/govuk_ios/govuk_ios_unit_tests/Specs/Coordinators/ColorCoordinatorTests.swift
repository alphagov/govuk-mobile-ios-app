import Foundation
import XCTest

@testable import govuk_ios

class ColorCoordinatorTests: XCTestCase {
    
    @MainActor 
    func test_start_setsViewController() {
        let mockNavigationController = MockNavigationController()
        let subject = ColorCoordinator(
            navigationController: mockNavigationController,
            color: .green,
            title: "Test",
            coordinatorBuilder: .mock
        )

        subject.start()
        
        XCTAssert(mockNavigationController._setViewControllers?.isEmpty == false)
        XCTAssertEqual(mockNavigationController._setViewControllers?.count, 1)
    }

}
