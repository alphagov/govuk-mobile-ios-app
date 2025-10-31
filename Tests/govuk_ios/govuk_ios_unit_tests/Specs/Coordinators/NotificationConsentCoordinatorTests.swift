import UIKit
import Foundation
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct NotificationConsentCoordinatorTests {
    @Test
    func start_alignedConsent_finishesCoordinator() async {
        let mockNavigationController = MockNavigationController()
        let mockNotificationService = MockNotificationService()

        let called = await withCheckedContinuation { continuation in
            let subject = NotificationConsentCoordinator(
                navigationController: mockNavigationController,
                notificationService: mockNotificationService,
                analyticsService: MockAnalyticsService(),
                consentResult: .aligned,
                coordinatorBuilder: MockCoordinatorBuilder.mock,
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
    func start_misaligned_consentGrantedNotificationsOff_rejectsConsent() async {
        let mockNavigationController = UINavigationController()
        let mockNotificationService = MockNotificationService()

        await withCheckedContinuation { continuation in
            let subject = NotificationConsentCoordinator(
                navigationController: mockNavigationController,
                notificationService: mockNotificationService,
                analyticsService: MockAnalyticsService(),
                consentResult: .misaligned(.consentGrantedNotificationsOff),
                coordinatorBuilder: MockCoordinatorBuilder.mock,
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
    func start_misaligned_consentNotGrantedNotificationsOn_presentsAlert() {
        let mockNavigationController = MockNavigationController()
        let mockNotificationService = MockNotificationService()
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedConsentAlertViewController = UIViewController()
        mockViewControllerBuilder._stubbedNotificationConsentAlertViewController = expectedConsentAlertViewController

        var completionCalled = false
        let subject = NotificationConsentCoordinator(
            navigationController: mockNavigationController,
            notificationService: mockNotificationService,
            analyticsService: MockAnalyticsService(),
            consentResult: .misaligned(.consentNotGrantedNotificationsOn),
            coordinatorBuilder: MockCoordinatorBuilder.mock,
            viewControllerBuilder: mockViewControllerBuilder,
            urlOpener: MockURLOpener(),
            completion: {
                completionCalled = true
            }
        )

        subject.start()

        #expect(mockNavigationController._presentedViewController == expectedConsentAlertViewController)
        #expect(!mockNotificationService._rejectConsentCalled)
        #expect(!completionCalled)
    }

    @Test
    func grantConsent_acceptsConsent() async {
        let mockNavigationController = MockNavigationController()
        let mockNotificationService = MockNotificationService()
        let mockViewControllerBuilder = MockViewControllerBuilder()

        let subject = NotificationConsentCoordinator(
            navigationController: mockNavigationController,
            notificationService: mockNotificationService,
            analyticsService: MockAnalyticsService(),
            consentResult: .misaligned(.consentNotGrantedNotificationsOn),
            coordinatorBuilder: MockCoordinatorBuilder.mock,
            viewControllerBuilder: mockViewControllerBuilder,
            urlOpener: MockURLOpener(),
            completion: { }
        )

        subject.start()

        mockViewControllerBuilder._receivedNotificationConsentAlertGrantConsentAction?()

        #expect(mockNotificationService._acceptConsentCalled)
    }

    @Test
    func openSettings_presentsAlert() async {
        let mockNavigationController = MockNavigationController()
        let mockNotificationService = MockNotificationService()
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockNotificationConsentAlertViewController = MockBaseViewController.mock

        mockViewControllerBuilder._stubbedNotificationConsentAlertViewController = mockNotificationConsentAlertViewController

        let subject = NotificationConsentCoordinator(
            navigationController: mockNavigationController,
            notificationService: mockNotificationService,
            analyticsService: MockAnalyticsService(),
            consentResult: .misaligned(.consentNotGrantedNotificationsOn),
            coordinatorBuilder: MockCoordinatorBuilder.mock,
            viewControllerBuilder: mockViewControllerBuilder,
            urlOpener: MockURLOpener(),
            completion: { }
        )

        subject.start()

        mockNavigationController.setViewControllers(
            [mockNotificationConsentAlertViewController],
            animated: false
        )

        let viewController = MockBaseViewController.mock
        mockViewControllerBuilder._receivedNotificationConsentAlertOpenSettingsAction?(viewController)
        let alert = viewController._presentedViewController as? UIAlertController
        #expect(alert != nil)
    }

    @Test
    func viewPrivacyAction_startsSafari() async {
        let mockNavigationController = MockNavigationController()
        let mockNotificationService = MockNotificationService()
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockNotificationConsentAlertViewController = MockBaseViewController.mock
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockSafariCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedSafariCoordinator = mockSafariCoordinator

        mockViewControllerBuilder._stubbedNotificationConsentAlertViewController = mockNotificationConsentAlertViewController

        let subject = NotificationConsentCoordinator(
            navigationController: mockNavigationController,
            notificationService: mockNotificationService,
            analyticsService: MockAnalyticsService(),
            consentResult: .misaligned(.consentNotGrantedNotificationsOn),
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            urlOpener: MockURLOpener(),
            completion: { }
        )

        subject.start()

        mockNavigationController.setViewControllers(
            [mockNotificationConsentAlertViewController],
            animated: false
        )

        mockViewControllerBuilder._receivedNotificationConsentAlertViewPrivacyAction?()
        #expect(mockSafariCoordinator._startCalled)
    }
}
