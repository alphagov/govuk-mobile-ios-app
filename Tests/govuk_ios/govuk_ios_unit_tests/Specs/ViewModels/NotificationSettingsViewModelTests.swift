import Foundation
import UIKit
import Testing
import Onboarding

@testable import govuk_ios
@testable import GOVKitTestUtilities

@Suite
struct NotificationSettingsViewModelTests {
    @Test
    func primaryButtonViewModelAction_callsRequestNotificationPermission() {
        let mockNotificationService = MockNotificationService()
        let mockAnalyticsService = MockAnalyticsService()
        let sut = NotificationSettingsViewModel(
            notificationService: mockNotificationService,
            analyticsService: mockAnalyticsService,
            completeAction: { }
        )
        sut.primaryButtonViewModel.action()

        #expect(mockNotificationService._receivedRequestPermissionsCompletion != nil)
    }

    @Test
    func primarybuttonAccessibilityHint_returnsExpectedResult() {
        let sut = NotificationSettingsViewModel(
            notificationService: MockNotificationService(),
            analyticsService: MockAnalyticsService(),
            completeAction: { }
        )
        #expect(
            sut.primarybuttonAccessibilityHint == Onboarding.notificationSlide.primaryButtonAccessibilityHint
        )
    }

    @Test
    func acceptingOrRejectingPermissions_callsCompletion() async {
        let result = await withCheckedContinuation { continuation in
            let mockNotificationService = MockNotificationService()
            let sut = NotificationSettingsViewModel(
                notificationService: mockNotificationService,
                analyticsService: MockAnalyticsService(),
                completeAction: {
                    continuation.resume(returning: true)
                }
            )
            sut.primaryButtonViewModel.action()
            mockNotificationService._receivedRequestPermissionsCompletion?()
        }
        #expect(result)
    }

    @Test
    func requestNotificationPermission_completionCalledAfterPermissionRequest() async {
        var completionCalled = false
        let mockNotificationService = MockNotificationService()
        let sut = NotificationSettingsViewModel(
            notificationService: mockNotificationService,
            analyticsService: MockAnalyticsService(),
            completeAction: {
                completionCalled = true
            }
        )
        sut.primaryButtonViewModel.action()
        #expect(!completionCalled)
        mockNotificationService._receivedRequestPermissionsCompletion?()
        #expect(completionCalled)
    }
}
