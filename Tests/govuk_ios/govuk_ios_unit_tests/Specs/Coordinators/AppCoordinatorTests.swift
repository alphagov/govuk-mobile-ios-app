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
}
