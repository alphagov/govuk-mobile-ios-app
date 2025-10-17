import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
struct LocalAuthenticationSettingsCoordinatorTests {
    @Test @MainActor
    func start_faceId_setsLocalAuthenticationSettingsCoordinator() {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockAnalyticsService = MockAnalyticsService()
        let mockNavigationController = MockNavigationController()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockAuthenticationService = MockAuthenticationService()
        mockLocalAuthenticationService._stubbedDeviceCapableAuthType = .faceID
        let stubbedFaceIdSettingsController = UIViewController()
        mockViewControllerBuilder._stubbedFaceIdSettingsController = stubbedFaceIdSettingsController
        let subject = LocalAuthenticationSettingsCoordinator(
            navigationController: mockNavigationController,
            authenticationService: mockAuthenticationService,
            localAuthenticationService: mockLocalAuthenticationService,
            analyticsService: mockAnalyticsService,
            viewControllerBuilder: mockViewControllerBuilder,
            urlOpener: MockURLOpener()
        )
        subject.start()

        #expect(mockNavigationController._pushedViewController == stubbedFaceIdSettingsController)
    }

    @Test @MainActor
    func start_touchId_setsLocalAuthenticationSettingsCoordinator() {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockAnalyticsService = MockAnalyticsService()
        let mockNavigationController = MockNavigationController()
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        let mockAuthenticationService = MockAuthenticationService()
        mockLocalAuthenticationService._stubbedDeviceCapableAuthType = .touchID
        let stubbedTouchIdSettingsController = UIViewController()
        mockViewControllerBuilder._stubbedTouchIdSettingsController = stubbedTouchIdSettingsController
        let subject = LocalAuthenticationSettingsCoordinator(
            navigationController: mockNavigationController,
            authenticationService: mockAuthenticationService,
            localAuthenticationService: mockLocalAuthenticationService,
            analyticsService: mockAnalyticsService,
            viewControllerBuilder: mockViewControllerBuilder,
            urlOpener: MockURLOpener()
        )
        subject.start()

        #expect(mockNavigationController._pushedViewController == stubbedTouchIdSettingsController)
    }
}
