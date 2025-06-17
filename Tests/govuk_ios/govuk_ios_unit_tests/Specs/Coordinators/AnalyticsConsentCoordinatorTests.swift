import Foundation
import SwiftUI
import UIKit
import Testing
import GOVKit

@testable import govuk_ios

@Suite
@MainActor
struct AnalyticsConsentCoordinatorTests {
    @Test
    func start_analyticsPermissionState_acceptedCallsDismiss() async {
        let mockAnalyticsService = MockAnalyticsService()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        mockAnalyticsService._stubbedPermissionState = .accepted
        let mockNavigationController = UINavigationController()

        let dismissed = await withCheckedContinuation { continuation in
            let sut = AnalyticsConsentCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: mockCoordinatorBuilder,
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
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        mockAnalyticsService._stubbedPermissionState = .denied
        let mockNavigationController = UINavigationController()
        let dismissed = await withCheckedContinuation { continuation in
            let sut = AnalyticsConsentCoordinator(
                navigationController: mockNavigationController,
                coordinatorBuilder: mockCoordinatorBuilder,
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
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        mockAnalyticsService._stubbedPermissionState = .unknown
        let mockNavigationController = UINavigationController()
        let sut = AnalyticsConsentCoordinator(
            navigationController: mockNavigationController,
            coordinatorBuilder: mockCoordinatorBuilder,
            analyticsService: mockAnalyticsService,
            completion: { }
        )
        sut.start()

        #expect(mockNavigationController.viewControllers.count == 1)
    }

    @Test
    @MainActor
    func openAction_startsSafariCoordinator() async {
        let mockAnalyticsService = MockAnalyticsService()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        let mockSafariCoordinator = MockBaseCoordinator()
        mockAnalyticsService._stubbedPermissionState = .unknown
        mockCoordinatorBuilder._stubbedSafariCoordinator = mockSafariCoordinator
        let mockNavigationController = UINavigationController()
        var receivedURL: URL?
        var safariCoordinatorStarted = false
        let viewModel = AnalyticsConsentContainerViewModel(
            analyticsService: mockAnalyticsService,
            openAction: { url in
                receivedURL = url
                safariCoordinatorStarted = true
            },
            completion: {}
        )
        viewModel.openPrivacyPolicy()
        let expectedURL = Constants.API.privacyPolicyUrl
        #expect(receivedURL == expectedURL)
        #expect(safariCoordinatorStarted)
    }
}

