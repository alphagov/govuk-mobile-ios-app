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
        mockAnalyticsService._stubbedPermissionState = .accepted
        let mockNavigationController = UINavigationController()

        let dismissed = await withCheckedContinuation { continuation in
            let sut = AnalyticsConsentCoordinator(
                navigationController: mockNavigationController,
                analyticsService: mockAnalyticsService,
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
        mockAnalyticsService._stubbedPermissionState = .denied
        let mockNavigationController = UINavigationController()
        let dismissed = await withCheckedContinuation { continuation in
            let sut = AnalyticsConsentCoordinator(
                navigationController: mockNavigationController,
                analyticsService: mockAnalyticsService,
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
        mockAnalyticsService._stubbedPermissionState = .unknown
        let mockNavigationController = UINavigationController()
        let sut = AnalyticsConsentCoordinator(
            navigationController: mockNavigationController,
            analyticsService: mockAnalyticsService,
            completion: { }
        )
        sut.start()

        #expect(mockNavigationController.viewControllers.count == 1)
    }
}
