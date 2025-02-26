import Foundation
import UserNotifications
import Testing

@testable import govuk_ios

@Suite
class NotificationServiceTests {

    @Test
    func fetchSlides_returnsExpectedSlides() async throws {
        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: MockUserNotificationCenter()
        )
        let result = await withCheckedContinuation { continuation in
            sut.fetchSlides(
                completion: {
                    continuation.resume(returning: $0)
                }
            )
        }
        let slides = try #require(try result.get())
        #expect(slides.count == 1)
    }

    @Test
    func shouldRequestPermissions_statusNotDetermined_returnsTrue() async {
        let mockUserNotificationCenter = MockUserNotificationCenter()
        mockUserNotificationCenter._stubbedAuthorizationStatus = .notDetermined
        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: mockUserNotificationCenter
        )
        #expect(await sut.shouldRequestPermission)
    }

    @Test(arguments: [
        UNAuthorizationStatus.authorized,
        UNAuthorizationStatus.denied,
        UNAuthorizationStatus.provisional,
        UNAuthorizationStatus.ephemeral
    ])
    func shouldRequestPermissions_statusDetermined_returnsFalse(status: UNAuthorizationStatus) async {
        let mockUserNotificationCenter = MockUserNotificationCenter()
        mockUserNotificationCenter._stubbedAuthorizationStatus = status
        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: mockUserNotificationCenter
        )
        #expect(await !sut.shouldRequestPermission)
    }
}
