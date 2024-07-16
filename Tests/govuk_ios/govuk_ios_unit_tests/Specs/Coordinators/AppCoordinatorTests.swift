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
            deeplinkService: MockDeeplinkService(), userDefaults: UserDefaults()
        )

        subject.start()

        XCTAssertEqual(mockCoodinatorBuilder._receivedLaunchNavigationController, mockNavigationController)
        XCTAssertTrue(mockLaunchCoodinator._startCalled)
    }
    
    @MainActor 
    func test_showOnboarding_whenUserDefaultsIsSetToTrue_OnboardingCoordinator_doesNotLaunch(){
        let userDefaults = MockUserDefaults()

        let mockCoodinatorBuilder = MockCoordinatorBuilder(
            container: .init()
        )
        let mockNavigationController = UINavigationController()
        let mockOnboardingCoodinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        mockCoodinatorBuilder._stubbedOnboardingCoordinator = mockOnboardingCoodinator

        let subject = AppCoordinator(
            coordinatorBuilder: mockCoodinatorBuilder,
            navigationController: mockNavigationController,
            deeplinkService: MockDeeplinkService(), userDefaults: userDefaults
        )
  
        subject.start()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            XCTAssertEqual(mockCoodinatorBuilder._receivedOnboardingNavigationController, mockNavigationController)
            XCTAssertTrue(mockOnboardingCoodinator._startCalled)
        }
    }
    
    

}
