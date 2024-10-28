import UIKit
import Foundation
import Testing

@testable import govuk_ios

@Suite
struct AppCoordinatorTests {
    @Test
    @MainActor
    func start_firstLaunch_startsLaunchCoordinator() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder.mock
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

        #expect(mockCoodinatorBuilder._receivedLaunchNavigationController == mockNavigationController)
        #expect(mockLaunchCoodinator._startCalled)
    }

    @Test
    @MainActor
    func start_secondLaunch_startsTabCoordinator() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder.mock
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

        #expect(mockLaunchCoodinator._startCalled)

        //Finish launch loading
        mockCoodinatorBuilder._receivedLaunchCompletion?()
        mockCoodinatorBuilder._receivedAnalyticsConsentDismissAction?()
        mockCoodinatorBuilder._receivedOnboardingDismissAction?()
        mockCoodinatorBuilder._received_TopicOnboardingDidDismissAction?()

        #expect(mockTabCoodinator._startCalled)

        //Reset values for second launch
        mockLaunchCoodinator._startCalled = false
        mockTabCoodinator._startCalled = false

        //Second launch
        subject.start()

        #expect(!mockLaunchCoodinator._startCalled)
        #expect(mockTabCoodinator._startCalled)
    }

}
