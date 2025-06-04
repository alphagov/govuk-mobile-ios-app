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
                viewControllerBuilder: MockViewControllerBuilder(),
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
                viewControllerBuilder: MockViewControllerBuilder(),
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
            viewControllerBuilder: MockViewControllerBuilder(),
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

    @Test
    @MainActor
    func grantConsent_acceptsConsent() async {
        let mockNavigationController = MockNavigationController()
        let mockNotificationService = MockNotificationService()
        let mockViewControllerBuilder = MockViewControllerBuilder()

        let subject = NotificationConsentCoordinator(
            navigationController: mockNavigationController,
            notificationService: mockNotificationService,
            analyticsService: MockAnalyticsService(),
            consentResult: .misaligned(.consentNotGrantedNotificationsOn),
            viewControllerBuilder: mockViewControllerBuilder,
            urlOpener: MockURLOpener(),
            completion: { }
        )

        subject.start()

        mockViewControllerBuilder._receivedNotificationConsentAlertGrantConsentAction?()

        #expect(mockNotificationService._acceptConsentCalled)
    }

    @Test
    @MainActor
    func openSettings_presentsAlert() async {
        let mockNavigationController = MockNavigationController()
        let mockNotificationService = MockNotificationService()
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockNotificationConsentAlertViewController = MockBaseViewController()

        mockViewControllerBuilder._stubbedNotificationConsentAlertViewController = mockNotificationConsentAlertViewController

        let subject = NotificationConsentCoordinator(
            navigationController: mockNavigationController,
            notificationService: mockNotificationService,
            analyticsService: MockAnalyticsService(),
            consentResult: .misaligned(.consentNotGrantedNotificationsOn),
            viewControllerBuilder: mockViewControllerBuilder,
            urlOpener: MockURLOpener(),
            completion: { }
        )

        subject.start()

        mockNavigationController.setViewControllers(
            [mockNotificationConsentAlertViewController],
            animated: false
        )

        mockViewControllerBuilder._receivedNotificationConsentAlertOpenSettingsAction?()
        let alert = mockNotificationConsentAlertViewController._presentedViewController as? UIAlertController
        #expect(alert != nil)
    }
}
