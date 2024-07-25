//

import XCTest
@testable import govuk_ios

final class OnboardingCoordinatorTests: XCTestCase {
    
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_start_ifUserDefaultsIsFalse_callsDismiss() throws {
        
        let mockNavigationController = UINavigationController()
        
        let sut = OnboardingCoordinator(navigationController: mockNavigationController, onboardingService: OnboardingService(userDefaults: UserDefaults()), dismissAction: {})
        
        

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
