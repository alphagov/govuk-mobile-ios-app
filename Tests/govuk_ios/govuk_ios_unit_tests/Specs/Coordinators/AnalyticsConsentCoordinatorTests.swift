import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct AnalyticsConsentCoordinatorTests {
    @Test
    func start_analyticsPermissionState_acceptedCallsDismiss() async {
        let mockAnalyticsService = MockAnalyticsService()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        mockAnalyticsService._stubbedPermissionState = .accepted
        let mockNavigationController = UINavigationController()

        let dismissed = await withCheckedContinuation { continuation in
            let sut = AnalyticsConsentCoordinator(
                navigationController: mockNavigationController,
                analyticsService: mockAnalyticsService,
                coordinatorBuilder: mockCoordinatorBuilder,
                viewControllerBuilder: MockViewControllerBuilder(),
                completion: {
                    continuation.resume(returning: true)
                }
            )
            sut.start()
        }
        #expect(dismissed)
    }

    @Test
    func start_analyticsPermissionState_deniedCallsDismiss() async {
        let mockAnalyticsService = MockAnalyticsService()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        mockAnalyticsService._stubbedPermissionState = .denied
        let mockNavigationController = UINavigationController()
        let dismissed = await withCheckedContinuation { continuation in
            let sut = AnalyticsConsentCoordinator(
                navigationController: mockNavigationController,
                analyticsService: mockAnalyticsService,
                coordinatorBuilder: mockCoordinatorBuilder,
                viewControllerBuilder: MockViewControllerBuilder(),
                completion: {
                    continuation.resume(returning: true)
                }
            )
            sut.start()
        }
        #expect(dismissed)
    }

    @Test
    func start_analyticsPermissionState_unknownDoesntCallDismiss() async {
        let mockAnalyticsService = MockAnalyticsService()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        mockAnalyticsService._stubbedPermissionState = .unknown
        let mockNavigationController = UINavigationController()
        let sut = AnalyticsConsentCoordinator(
            navigationController: mockNavigationController,
            analyticsService: mockAnalyticsService,
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: MockViewControllerBuilder(),
            completion: { }
        )
        sut.start()

        #expect(mockNavigationController.viewControllers.count == 1)
    }

    @Test
    @MainActor
    func viewPrivacyAction_startsSafari() async {
        let mockNavigationController = MockNavigationController()
        let mockViewControllerBuilder = MockViewControllerBuilder.mock
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockSafariCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedSafariCoordinator = mockSafariCoordinator
        let mockAnalyticsService = MockAnalyticsService()
        mockAnalyticsService._stubbedPermissionState = .unknown
        await withCheckedContinuation { continuation in
            let sut = AnalyticsConsentCoordinator(
                navigationController: mockNavigationController,
                analyticsService: mockAnalyticsService,
                coordinatorBuilder: mockCoordinatorBuilder,
                viewControllerBuilder: mockViewControllerBuilder,
                completion: { }
            )
            mockSafariCoordinator._startCalledAction = {
                continuation.resume()
            }
            mockNavigationController._setViewControllersCalledAction = {
                mockViewControllerBuilder._receivedAnalyticsConsentViewPrivacyAction?()
            }
            sut.start(url: nil)
        }
        #expect(mockSafariCoordinator._startCalled)
    }
}
