import UIKit
import Foundation
import Testing

@testable import govuk_ios

@Suite
struct ReLaunchCoordinatorTests {
    @Test
    @MainActor
    func start_alignedConsent_completes() async {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockNavigationController = UINavigationController()
        let mockConsentCoordinator = MockBaseCoordinator(
            navigationController: mockNavigationController
        )
        mockCoordinatorBuilder._stubbedNotificationConsentCoordinator = mockConsentCoordinator
        let mockNotificationService = MockNotificationService()
        mockNotificationService._stubbedFetchConsentAlignmentResult = .aligned
        await withCheckedContinuation { continuation in
            let subject = ReLaunchCoordinator(
                coordinatorBuilder: mockCoordinatorBuilder,
                notificationService: mockNotificationService,
                navigationController: mockNavigationController,
                completion: {
                    continuation.resume()
                }
            )
            mockConsentCoordinator._startCalledAction = {
                mockCoordinatorBuilder._receivedNotificationConsentCompletion?()
            }
            subject.start()
        }

        #expect(mockConsentCoordinator._startCalled)
    }
}

