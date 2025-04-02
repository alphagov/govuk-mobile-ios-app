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
        let slides = try result.get()
        #expect(slides.count == 1)
    }

    //    @Test
    //    func shouldRequestPermissions_statusNotDetermined_returnsTrue() async {
    //        let mockUserNotificationCenter = MockUserNotificationCenter()
    //        mockUserNotificationCenter._stubbedAuthorizationStatus = .notDetermined
    //        let sut = NotificationService(
    //            environmentService: MockAppEnvironmentService(),
    //            notificationCenter: mockUserNotificationCenter
    //        )
    //        #expect(await sut.shouldRequestPermission)
    //    }

    @Test(arguments: [
        UNAuthorizationStatus.authorized,
        //        UNAuthorizationStatus.denied,
        //        UNAuthorizationStatus.provisional,
        //        UNAuthorizationStatus.ephemeral
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

    @Test
    func isFeatureEnabled_returnsExpectedValue() async throws {
        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: MockUserNotificationCenter()
        )
        #expect(!sut.isFeatureEnabled)
    }


    @Test
    func authorizationStatus_whenAuthorizationStatusIsAuthorised_returnsCorrectAuthorizationStatus() async {
        let notificationCenter = MockUserNotificationCenter()
        notificationCenter._stubbedAuthorizationStatus = .authorized

        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: notificationCenter
        )
        #expect(await sut.authorizationStatus == .authorized)
    }

    @Test
    func authorizationStatus_whenAuthorizationStatusIsDenied_returnsCorrectAuthorizationStatus() async {
        let notificationCenter = MockUserNotificationCenter()
        notificationCenter._stubbedAuthorizationStatus = .denied

        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: notificationCenter
        )
        #expect(await sut.authorizationStatus == .denied)
    }

    @Test
    func authorizationStatus_whenAuthorizationStatusIsNotDetermined_returnsCorrectAuthorizationStatus() async {
        let notificationCenter = MockUserNotificationCenter()
        notificationCenter._stubbedAuthorizationStatus = .notDetermined

        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: notificationCenter
        )
        #expect(await sut.authorizationStatus == .notDetermined)
    }

    @Test
    func authorizationStatus_whenAuthorizationStatusIsEphemeral_returnsCorrectAuthorizationStatus() async {
        let notificationCenter = MockUserNotificationCenter()
        notificationCenter._stubbedAuthorizationStatus = .ephemeral

        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: notificationCenter
        )
        #expect(await sut.authorizationStatus == .notDetermined)
    }

    @Test
    func authorizationStatus_whenAuthorizationStatusIsProvisional_returnsCorrectAuthorizationStatus() async {
        let notificationCenter = MockUserNotificationCenter()
        notificationCenter._stubbedAuthorizationStatus = .provisional

        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: notificationCenter
        )
        #expect(await sut.authorizationStatus == .notDetermined)
    }
}
