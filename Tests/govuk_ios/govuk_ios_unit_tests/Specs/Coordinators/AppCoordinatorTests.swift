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
<<<<<<< HEAD
            navigationController: mockNavigationController,
            deeplinkService: MockDeeplinkService(), userDefaults: UserDefaults()
=======
            navigationController: mockNavigationController
>>>>>>> develop
        )

        subject.start()

        XCTAssertEqual(mockCoodinatorBuilder._receivedLaunchNavigationController, mockNavigationController)
        XCTAssertTrue(mockLaunchCoodinator._startCalled)
    }
    
    @MainActor 
    func test_start_hasOnboardedIsFalse_launchesOnboardingCoordinator(){
        //Given
        let userDefaults = MockUserDefaults()
        userDefaults.setFlag(forkey: .hasOnboarded, to: false)
        let mockCoodinatorBuilder = MockCoordinatorBuilder(
            container: .init()
        )
        let mockNavigationController = UINavigationController()
        let mockOnboardingCoodinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        mockCoodinatorBuilder._stubbedOnboardingCoordinator = mockOnboardingCoodinator

<<<<<<< HEAD
        let subject = AppCoordinator(
            coordinatorBuilder: mockCoodinatorBuilder,
            navigationController: mockNavigationController,
            deeplinkService: MockDeeplinkService(), userDefaults: userDefaults
        )
        //When
        subject.start()
        mockCoodinatorBuilder._receivedLaunchCompletion?()
        //Then
            XCTAssertEqual(mockCoodinatorBuilder._receivedOnboardingNavigationController, mockNavigationController)
            XCTAssertTrue(mockOnboardingCoodinator._startCalled)
    }
     
    @MainActor
    func test_start_hasOnboardedIsTrue_doesNotLaunchOnboardingCoordinator(){
        //Given
        let userDefaults = MockUserDefaults()
        userDefaults.setFlag(forkey: .hasOnboarded, to: true)
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
        //When
        subject.start()
        mockCoodinatorBuilder._receivedLaunchCompletion?()
        //Then
        XCTAssertEqual(mockCoodinatorBuilder._receivedOnboardingNavigationController, nil)
        XCTAssertFalse(mockOnboardingCoodinator._startCalled)
    }
=======
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

>>>>>>> develop
}
