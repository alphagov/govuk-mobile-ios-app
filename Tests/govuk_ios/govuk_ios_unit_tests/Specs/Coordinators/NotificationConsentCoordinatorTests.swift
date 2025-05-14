import UIKit
import Foundation
import Testing

@testable import govuk_ios
@testable import GOVKitTestUtilities

@Suite
struct NotificationConsentCoordinatorTests {
    @Test
    @MainActor
    func start_alignedConsent_finishesCoordinator() async {
        let mockNavigationController = MockNavigationController()
        let mockNotificationService = MockNotificationService()

        let called = await withCheckedContinuation { continuation in
            let subject = NotificationConsentCoordinator(
                navigationController: mockNavigationController,
                notificationService: mockNotificationService,
                analyticsService: MockAnalyticsService(),
                consentResult: .aligned,
                urlOpener: MockURLOpener(),
                completion: {
                    continuation.resume(returning: true)
                }
            )

            subject.start()
        }

        #expect(called)
    }

    @Test
    @MainActor
    func start_misaligned_consentGrantedNotificationsOff_rejectsConsent() async {
        let mockNavigationController = UINavigationController()
        let mockNotificationService = MockNotificationService()

        await withCheckedContinuation { continuation in
            let subject = NotificationConsentCoordinator(
                navigationController: mockNavigationController,
                notificationService: mockNotificationService,
                analyticsService: MockAnalyticsService(),
                consentResult: .misaligned(.consentGrantedNotificationsOff),
                urlOpener: MockURLOpener(),
                completion: {
                    continuation.resume()
                }
            )

            subject.start()
        }

        #expect(mockNotificationService._rejectConsentCalled)
    }

    @Test
    @MainActor
    func start_misaligned_consentNotGrantedNotificationsOn_presentsAlert() async {
        let mockNavigationController = MockNavigationController()
        let mockNotificationService = MockNotificationService()

        var completionCalled = false
        let subject = NotificationConsentCoordinator(
            navigationController: mockNavigationController,
            notificationService: mockNotificationService,
            analyticsService: MockAnalyticsService(),
            consentResult: .misaligned(.consentNotGrantedNotificationsOn),
            urlOpener: MockURLOpener(),
            completion: {
                completionCalled = true
            }
        )

        subject.start()

        #expect(mockNavigationController._presentedViewController is NotificationConsentAlertViewController)
        #expect(!mockNotificationService._rejectConsentCalled)
        #expect(!completionCalled)
    }
}
