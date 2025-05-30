import UIKit
import Foundation
import Testing

@testable import govuk_ios

@Suite
struct AppCoordinatorTests {
    @Test
    @MainActor
    func start_firstLaunch_startsLaunchCoordinator() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockNavigationController = UINavigationController()
        let mockInactivityService = MockInactivityService()
        let mockCoordinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        mockCoordinatorBuilder._stubbedPreAuthCoordinator = mockCoordinator

        let subject = AppCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            inactivityService: mockInactivityService,
            navigationController: mockNavigationController
        )

        subject.start()

        #expect(mockCoordinatorBuilder._receivedPreAuthNavigationController == mockNavigationController)
        #expect(mockCoordinator._startCalled)
    }

    @Test
    @MainActor
    func start_secondLaunch_startsTabCoordinator() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockNavigationController = UINavigationController()
        let mockInactivityService = MockInactivityService()
        let mockPreAuthCoordinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        let mockTabCoordinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        mockCoordinatorBuilder._stubbedPreAuthCoordinator = mockPreAuthCoordinator
        mockCoordinatorBuilder._stubbedTabCoordinator = mockTabCoordinator

        let subject = AppCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            inactivityService: mockInactivityService,
            navigationController: mockNavigationController
        )

        //First launch
        subject.start()

        #expect(mockPreAuthCoordinator._startCalled)

        mockCoordinatorBuilder._receivedPreAuthCompletion?()
        mockCoordinatorBuilder._receivedPeriAuthCompletion?()
        mockCoordinatorBuilder._receivedPostAuthCompletion?()

        #expect(mockTabCoordinator._startCalled)

        //Reset values for second launch
        mockPreAuthCoordinator._startCalled = false
        mockTabCoordinator._startCalled = false

        //Second launch
        subject.start()

        #expect(!mockPreAuthCoordinator._startCalled)
    }

    @Test
    @MainActor
    func successfulSignout_startsLoginCoordinator() throws {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockNavigationController = UINavigationController()
        let mockInactivityService = MockInactivityService()
        let mockLaunchCoordinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        mockCoordinatorBuilder._stubbedLaunchCoordinator = mockLaunchCoordinator

        let tabCoordinator = TabCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: mockNavigationController,
            analyticsService: MockAnalyticsService()
        )

        let periAuthCoordinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )

        mockCoordinatorBuilder._stubbedTabCoordinator = tabCoordinator
        mockCoordinatorBuilder._stubbedPeriAuthCoordinator = periAuthCoordinator

        let subject = AppCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            inactivityService: mockInactivityService,
            navigationController: mockNavigationController
        )

        //First launch
        subject.start()

        mockCoordinatorBuilder._receivedPreAuthCompletion?()
        mockCoordinatorBuilder._receivedPeriAuthCompletion?()
        mockCoordinatorBuilder._receivedPostAuthCompletion?()

        tabCoordinator.finish()
        #expect(periAuthCoordinator._startCalled)
    }
}
