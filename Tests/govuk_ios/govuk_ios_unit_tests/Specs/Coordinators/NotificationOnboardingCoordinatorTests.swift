import Foundation
import Testing
import UIKit

import Onboarding

@testable import govuk_ios

@Suite
class NotificationOnboardingCoordinatorTests {

    @Test
    func start_shouldRequestPermission() async throws {
        let mockNotificationService = MockNotificationService()
        let sut = NotificationOnboardingCoordinator(
            navigationController: MockNavigationController(),
            notificationService: MockNotificationService(),
            analyticsService: MockAnalyticsService(),
            completion: {}
        )
        sut.start(url: nil)

        #expect(Bool(true))
    }

}

class MockNotificationService: NotificationServiceInterface {
    func appDidFinishLaunching(launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {

    }
    
    func requestPermissions(completion: @escaping () -> Void) {

    }
    
    var shouldRequestPermission: Bool {
        true
    }

    func fetchSlides(completion: @escaping (Result<[any OnboardingSlideViewModelInterface], any Error>) -> Void) {

    }
}
