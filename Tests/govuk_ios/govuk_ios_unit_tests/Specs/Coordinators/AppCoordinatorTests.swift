import UIKit
import Foundation
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct AppCoordinatorTests {
    @Test
    func start_firstLaunch_startsLaunchCoordinator() {
        let mockAuthenticationService = MockAuthenticationService()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockNavigationController = UINavigationController()
        let mockInactivityService = MockInactivityService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockCoordinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        mockCoordinatorBuilder._stubbedPreAuthCoordinator = mockCoordinator

        let subject = AppCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            inactivityService: mockInactivityService,
            authenticationService: mockAuthenticationService,
            localAuthenticationService: mockLocalAuthenticationService,
            navigationController: mockNavigationController
        )

        subject.start()

        #expect(mockCoordinatorBuilder._receivedPreAuthNavigationController == mockNavigationController)
        #expect(mockCoordinator._startCalled)
        #expect(mockAuthenticationService.didSignOutAction != nil)
    }

    @Test
    func start_secondLaunch_startsTabCoordinator() {
        let mockAuthenticationService = MockAuthenticationService()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockNavigationController = UINavigationController()
        let mockInactivityService = MockInactivityService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
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
            authenticationService: mockAuthenticationService,
            localAuthenticationService: mockLocalAuthenticationService,
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
        let mockAuthenticationService = MockAuthenticationService()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockNavigationController = UINavigationController()
        let mockInactivityService = MockInactivityService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
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
            authenticationService: mockAuthenticationService,
            localAuthenticationService: mockLocalAuthenticationService,
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
        let mockAuthenticationService = MockAuthenticationService()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockNavigationController = UINavigationController()
        let mockInactivityService = MockInactivityService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
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
            authenticationService: mockAuthenticationService,
            localAuthenticationService: mockLocalAuthenticationService,
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
        let mockAuthenticationService = MockAuthenticationService()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockNavigationController = UINavigationController()
        let mockInactivityService = MockInactivityService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
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
            authenticationService: mockAuthenticationService,
            localAuthenticationService: mockLocalAuthenticationService,
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
        let mockAuthenticationService = MockAuthenticationService()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockNavigationController = UINavigationController()
        let mockInactivityService = MockInactivityService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()

        let mockPeriAuthCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedPeriAuthCoordinator = mockPeriAuthCoordinator
        mockAuthenticationService._stubbedIsSignedIn = true

        let subject = AppCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            inactivityService: mockInactivityService,
            authenticationService: mockAuthenticationService,
            localAuthenticationService: mockLocalAuthenticationService,
            navigationController: mockNavigationController
        )

        subject.start(url: nil)
        mockInactivityService._receivedStartMonitoringInactivityHandler?()

        #expect(mockPeriAuthCoordinator._startCalled)
    }

    @Test(arguments: [
        SignoutReason.tokenRefreshFailure,
        SignoutReason.userSignout,
    ])
    func start_didSignOutAction_userSignout_startsPeriAuthCoordinator(reason: SignoutReason) {
        let mockAuthenticationService = MockAuthenticationService()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockNavigationController = UINavigationController()
        let mockInactivityService = MockInactivityService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockCoordinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        mockCoordinatorBuilder._stubbedPreAuthCoordinator = mockCoordinator

        let mockPeriAuthCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedPeriAuthCoordinator = mockPeriAuthCoordinator

        let subject = AppCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            inactivityService: mockInactivityService,
            authenticationService: mockAuthenticationService,
            localAuthenticationService: mockLocalAuthenticationService,
            navigationController: mockNavigationController
        )

        subject.start(url: nil)

        mockAuthenticationService.didSignOutAction?(reason)

        #expect(mockPeriAuthCoordinator._startCalled)
    }

    @Test
    func start_didSignOutAction_reauthFailed_startsPeriAuthCoordinator() {
        let mockAuthenticationService = MockAuthenticationService()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockNavigationController = UINavigationController()
        let mockInactivityService = MockInactivityService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockCoordinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        mockCoordinatorBuilder._stubbedPreAuthCoordinator = mockCoordinator

        let mockPeriAuthCoordinator = MockBaseCoordinator()
        let mockPrivacyService = MockPrivacyService()
        mockCoordinatorBuilder._stubbedPeriAuthCoordinator = mockPeriAuthCoordinator

        let subject = AppCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            inactivityService: mockInactivityService,
            authenticationService: mockAuthenticationService,
            localAuthenticationService: mockLocalAuthenticationService,
            privacyPresenter: mockPrivacyService,
            navigationController: mockNavigationController
        )

        subject.start(url: nil)

        mockAuthenticationService.didSignOutAction?(.reauthFailure)

        #expect(!mockPeriAuthCoordinator._startCalled)
        #expect(mockPrivacyService._didHidePrivacyScreen)
    }

    @Test
    func inactivityWithBiometrics_presentsPrivacyScreen() {
        let mockAuthenticationService = MockAuthenticationService()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockNavigationController = UINavigationController()
        let mockInactivityService = MockInactivityService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAvailableAuthType = .faceID
        let mockPrivacyService = MockPrivacyService()

        let subject = AppCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            inactivityService: mockInactivityService,
            authenticationService: mockAuthenticationService,
            localAuthenticationService: mockLocalAuthenticationService,
            privacyPresenter: mockPrivacyService,
            navigationController: mockNavigationController
        )
        mockAuthenticationService._stubbedIsSignedIn = true
        subject.start()
        mockInactivityService._receivedStartMonitoringInactivityHandler?()

        #expect(mockPrivacyService._didShowPrivacyScreen)
    }

    @Test
    func inactivityWithoutBiometrics_doesntPresentsPrivacyScreen() {
        let mockAuthenticationService = MockAuthenticationService()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockNavigationController = UINavigationController()
        let mockInactivityService = MockInactivityService()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAvailableAuthType = .none
        mockLocalAuthenticationService._stubbedTouchIdEnabled = false
        let mockPrivacyService = MockPrivacyService()

        let subject = AppCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            inactivityService: mockInactivityService,
            authenticationService: mockAuthenticationService,
            localAuthenticationService: mockLocalAuthenticationService,
            navigationController: mockNavigationController
        )
        mockAuthenticationService._stubbedIsSignedIn = true
        subject.start()
        mockInactivityService._receivedStartMonitoringInactivityHandler?()

        #expect(!mockPrivacyService._didShowPrivacyScreen)
    }
}
