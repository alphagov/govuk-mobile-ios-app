import UIKit
import Foundation
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct AppCoordinatorTests {
    @Test
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
        let mockRelaunchCoordinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        mockCoordinatorBuilder._stubbedPreAuthCoordinator = mockPreAuthCoordinator
        mockCoordinatorBuilder._stubbedTabCoordinator = mockTabCoordinator
        mockCoordinatorBuilder._stubbedRelaunchCoordinator = mockRelaunchCoordinator

        let subject = AppCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            inactivityService: mockInactivityService,
            navigationController: mockNavigationController
        )

        //First launch
        subject.start()

        #expect(mockPreAuthCoordinator._startCalled)
        #expect(!mockRelaunchCoordinator._startCalled)

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
        #expect(mockRelaunchCoordinator._startCalled)
    }

    @Test
    func relaunchCompletion_withTabCoordinator_withURL_startsTabCoordinator() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockNavigationController = UINavigationController()
        let mockInactivityService = MockInactivityService()
        let mockPreAuthCoordinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        let mockTabCoordinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        let mockRelaunchCoordinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        mockCoordinatorBuilder._stubbedPreAuthCoordinator = mockPreAuthCoordinator
        mockCoordinatorBuilder._stubbedTabCoordinator = mockTabCoordinator
        mockCoordinatorBuilder._stubbedRelaunchCoordinator = mockRelaunchCoordinator

        let subject = AppCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            inactivityService: mockInactivityService,
            navigationController: mockNavigationController
        )

        //First launch
        subject.start()

        #expect(mockPreAuthCoordinator._startCalled)
        #expect(!mockRelaunchCoordinator._startCalled)

        mockCoordinatorBuilder._receivedPreAuthCompletion?()
        mockCoordinatorBuilder._receivedPeriAuthCompletion?()
        mockCoordinatorBuilder._receivedPostAuthCompletion?()

        #expect(mockTabCoordinator._startCalled)

        //Reset values for second launch
        mockPreAuthCoordinator._startCalled = false
        mockTabCoordinator._startCalled = false

        //Second launch
        let expectedURL = URL(string: "https://www.google.com")
        subject.start(url: expectedURL)

        #expect(mockRelaunchCoordinator._startCalled)

        mockCoordinatorBuilder._receivedRelaunchCompletion?()

        #expect(mockTabCoordinator._startCalled)
        #expect(mockTabCoordinator._receivedStartURL == expectedURL)
    }

    @Test
    func relaunchCompletion_withTabCoordinator_withNo_doesntStartTabCoordinator() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockNavigationController = UINavigationController()
        let mockInactivityService = MockInactivityService()
        let mockPreAuthCoordinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        let mockTabCoordinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        let mockRelaunchCoordinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        mockCoordinatorBuilder._stubbedPreAuthCoordinator = mockPreAuthCoordinator
        mockCoordinatorBuilder._stubbedTabCoordinator = mockTabCoordinator
        mockCoordinatorBuilder._stubbedRelaunchCoordinator = mockRelaunchCoordinator

        let subject = AppCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            inactivityService: mockInactivityService,
            navigationController: mockNavigationController
        )

        //First launch
        subject.start()

        #expect(mockPreAuthCoordinator._startCalled)
        #expect(!mockRelaunchCoordinator._startCalled)

        mockCoordinatorBuilder._receivedPreAuthCompletion?()
        mockCoordinatorBuilder._receivedPeriAuthCompletion?()
        mockCoordinatorBuilder._receivedPostAuthCompletion?()

        #expect(mockTabCoordinator._startCalled)

        //Reset values for second launch
        mockPreAuthCoordinator._startCalled = false
        mockTabCoordinator._startCalled = false

        //Second launch
        subject.start(url: nil)

        #expect(mockRelaunchCoordinator._startCalled)

        mockCoordinatorBuilder._receivedRelaunchCompletion?()

        #expect(!mockTabCoordinator._startCalled)
    }

    @Test
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


    @Test
    func inactivity_startsPeriAuth() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockNavigationController = UINavigationController()
        let mockInactivityService = MockInactivityService()

        let mockPeriAuthCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedPeriAuthCoordinator = mockPeriAuthCoordinator

        let subject = AppCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            inactivityService: mockInactivityService,
            navigationController: mockNavigationController
        )

        subject.start(url: nil)
        mockInactivityService._receivedStartMonitoringInactivityHandler?()

        #expect(mockPeriAuthCoordinator._startCalled)
    }
}
