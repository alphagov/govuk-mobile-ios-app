import Foundation
import UserNotifications
import Testing

@testable import govuk_ios

@Suite
class NotificationServiceTests {
//    @Test
//    func shouldRequestPermissions_statusNotDetermined_returnsTrue() async {
//        let mockUserNotificationCenter = MockUserNotificationCenter()
//        mockUserNotificationCenter._stubbedAuthorizationStatus = .notDetermined
//        let sut = NotificationService(
//            environmentService: MockAppEnvironmentService(),
//            notificationCenter: mockUserNotificationCenter,
//            userDefaults: MockUserDefaults()
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
            notificationCenter: mockUserNotificationCenter,
            configService: MockAppConfigService(),
            userDefaults: MockUserDefaultsService()
        )
        #expect(await !sut.shouldRequestPermission)
    }

    @Test
    func isFeatureEnabled_enabled_returnsExpectedValue() async throws {
        let mockConfig = MockAppConfigService()
        mockConfig.features = [.notifications]

        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: MockUserNotificationCenter(),
            configService: mockConfig,
            userDefaults: MockUserDefaultsService()
        )
        #expect(sut.isFeatureEnabled)
    }

    @Test
    func isFeatureEnabled_disabled_returnsExpectedValue() async throws {
        let mockConfig = MockAppConfigService()
        mockConfig.features = []
        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: MockUserNotificationCenter(),
            configService: mockConfig,
            userDefaults: MockUserDefaultsService()
        )
        #expect(!sut.isFeatureEnabled)
    }

    @Test
    func authorizationStatus_whenAuthorizationStatusIsAuthorised_returnsCorrectAuthorizationStatus() async {
        let notificationCenter = MockUserNotificationCenter()
        notificationCenter._stubbedAuthorizationStatus = .authorized

        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: notificationCenter,
            configService: MockAppConfigService(),
            userDefaults: MockUserDefaultsService()
        )
        #expect(await sut.permissionState == .authorized)
    }

    @Test
    func authorizationStatus_whenAuthorizationStatusIsDenied_returnsCorrectAuthorizationStatus() async {
        let notificationCenter = MockUserNotificationCenter()
        notificationCenter._stubbedAuthorizationStatus = .denied

        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: notificationCenter,
            configService: MockAppConfigService(),
            userDefaults: MockUserDefaultsService()
        )
        #expect(await sut.permissionState == .denied)
    }

    @Test
    func authorizationStatus_whenAuthorizationStatusIsNotDetermined_returnsCorrectAuthorizationStatus() async {
        let notificationCenter = MockUserNotificationCenter()
        notificationCenter._stubbedAuthorizationStatus = .notDetermined

        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: notificationCenter,
            configService: MockAppConfigService(),
            userDefaults: MockUserDefaultsService()
        )
        #expect(await sut.permissionState == .notDetermined)
    }

    @Test
    func authorizationStatus_whenAuthorizationStatusIsEphemeral_returnsCorrectAuthorizationStatus() async {
        let notificationCenter = MockUserNotificationCenter()
        notificationCenter._stubbedAuthorizationStatus = .ephemeral

        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: notificationCenter,
            configService: MockAppConfigService(),
            userDefaults: MockUserDefaultsService()
        )
        #expect(await sut.permissionState == .notDetermined)
    }

    @Test
    func authorizationStatus_whenAuthorizationStatusIsProvisional_returnsCorrectAuthorizationStatus() async {
        let notificationCenter = MockUserNotificationCenter()
        notificationCenter._stubbedAuthorizationStatus = .provisional

        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: notificationCenter,
            configService: MockAppConfigService(),
            userDefaults: MockUserDefaultsService()
        )
        #expect(await sut.permissionState == .notDetermined)
    }

    @Test
    func addClickListener_assignsOnClick() {
        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: MockUserNotificationCenter(),
            configService: MockAppConfigService(),
            userDefaults: MockUserDefaultsService()
        )
        let onClickAction: ((URL) -> Void)? = { _ in }
        sut.addClickListener(
            onClickAction: onClickAction!
        )
        #expect(sut.onClickAction != nil)
    }

    @Test
    func handleAdditionalData_whenAdditionalDataIsNil_doesNotCallOnClickAction() {
        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: MockUserNotificationCenter(),
            configService: MockAppConfigService(),
            userDefaults: MockUserDefaultsService()
        )

        var didOnClickAction = false
        sut.onClickAction = { _ in
            didOnClickAction = true
        }

        let additionalData: [AnyHashable: Any]? = nil
        sut.handleAdditionalData(additionalData)

        #expect(didOnClickAction == false)
    }

    @Test
    func handleAdditionalData_whenAdditionalDataIsEmpty_doesNotCallOnClickAction() {
        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: MockUserNotificationCenter(),
            configService: MockAppConfigService(),
            userDefaults: MockUserDefaultsService()
        )

        var didOnClickAction = false
        sut.onClickAction = { _ in
            didOnClickAction = true
        }

        let additionalData: [AnyHashable: Any]? = [:]
        sut.handleAdditionalData(additionalData)

        #expect(didOnClickAction == false)
    }

    @Test
    func handleAdditionalData_whenAdditionalDataDeeplinkCannotBeParsedToAUrl_doesNotCallOnClickAction() {
        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: MockUserNotificationCenter(),
            configService: MockAppConfigService(),
            userDefaults: MockUserDefaultsService()
        )

        var didOnClickAction = false
        sut.onClickAction = { _ in
            didOnClickAction = true
        }

        let additionalData: [AnyHashable: Any]? = ["deeplink": ""]
        sut.handleAdditionalData(additionalData)

        #expect(didOnClickAction == false)
    }

    @Test
    func handleAdditionalData_whenAdditionalDataIsValid_onClickActionHasTheCorrectUrl() {
        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: MockUserNotificationCenter(),
            configService: MockAppConfigService(),
            userDefaults: MockUserDefaultsService()
        )

        var result: URL?
        sut.onClickAction = { url in
            result = url
        }

        let additionalData: [AnyHashable: Any]? = ["deeplink": "scheme://host"]
        sut.handleAdditionalData(additionalData)

        #expect(result?.absoluteString == "scheme://host")
    }

    @Test
    func acceptConsent_whenNotAccepted_acceptsConsent() {
        let mockDefaults = MockUserDefaultsService()
        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: MockUserNotificationCenter(),
            configService: MockAppConfigService(),
            userDefaults: mockDefaults
        )

        sut.acceptConsent()

        #expect(mockDefaults.bool(forKey: .notificationsConsentGranted))
    }

    @Test
    func acceptConsent_whenRejected_acceptsConsent() {
        let mockDefaults = MockUserDefaultsService()
        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: MockUserNotificationCenter(),
            configService: MockAppConfigService(),
            userDefaults: mockDefaults
        )

        mockDefaults.set(bool: false, forKey: .notificationsConsentGranted)

        sut.acceptConsent()

        #expect(mockDefaults.bool(forKey: .notificationsConsentGranted))
    }

    @Test
    func acceptConsent_whenAccepted_remainsAccepted() {
        let mockDefaults = MockUserDefaultsService()
        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: MockUserNotificationCenter(),
            configService: MockAppConfigService(),
            userDefaults: mockDefaults
        )

        mockDefaults.set(bool: true, forKey: .notificationsConsentGranted)

        sut.acceptConsent()

        #expect(mockDefaults.bool(forKey: .notificationsConsentGranted))
    }

    @Test
    func rejectConsent_whenNotAccepted_rejectsConsent() {
        let mockDefaults = MockUserDefaultsService()
        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: MockUserNotificationCenter(),
            configService: MockAppConfigService(),
            userDefaults: mockDefaults
        )

        sut.rejectConsent()

        #expect(!mockDefaults.bool(forKey: .notificationsConsentGranted))
    }

    @Test
    func rejectConsent_whenRejected_remainsRejected() {
        let mockDefaults = MockUserDefaultsService()
        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: MockUserNotificationCenter(),
            configService: MockAppConfigService(),
            userDefaults: mockDefaults
        )

        mockDefaults.set(bool: false, forKey: .notificationsConsentGranted)

        sut.rejectConsent()

        #expect(!mockDefaults.bool(forKey: .notificationsConsentGranted))
    }

    @Test
    func rejectConsent_whenAccepted_rejectsConsent() {
        let mockDefaults = MockUserDefaultsService()
        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: MockUserNotificationCenter(),
            configService: MockAppConfigService(),
            userDefaults: mockDefaults
        )

        mockDefaults.set(bool: true, forKey: .notificationsConsentGranted)

        sut.rejectConsent()

        #expect(!mockDefaults.bool(forKey: .notificationsConsentGranted))
    }

    @Test
    func toggleHasGivenConsent_whenAccepted_rejectsConsent() {
        let mockDefaults = MockUserDefaultsService()
        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: MockUserNotificationCenter(),
            configService: MockAppConfigService(),
            userDefaults: mockDefaults
        )

        mockDefaults.set(bool: true, forKey: .notificationsConsentGranted)

        sut.toggleHasGivenConsent()

        #expect(!mockDefaults.bool(forKey: .notificationsConsentGranted))
    }

    @Test
    func toggleHasGivenConsent_whenRejected_acceptsConsent() {
        let mockDefaults = MockUserDefaultsService()
        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: MockUserNotificationCenter(),
            configService: MockAppConfigService(),
            userDefaults: mockDefaults
        )

        mockDefaults.set(bool: false, forKey: .notificationsConsentGranted)

        sut.toggleHasGivenConsent()

        #expect(mockDefaults.bool(forKey: .notificationsConsentGranted))
    }

    @Test
    func toggleHasGivenConsent_consentNotSet_acceptsConsent() {
        let mockDefaults = MockUserDefaultsService()
        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: MockUserNotificationCenter(),
            configService: MockAppConfigService(),
            userDefaults: mockDefaults
        )

        sut.toggleHasGivenConsent()

        #expect(mockDefaults.bool(forKey: .notificationsConsentGranted))
    }

    @Test
    func requestPermissions_consentGranted_doesNothing() {
        let mockDefaults = MockUserDefaultsService()
        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: MockUserNotificationCenter(),
            configService: MockAppConfigService(),
            userDefaults: mockDefaults
        )

        mockDefaults.set(bool: true, forKey: .notificationsConsentGranted)

        sut.requestPermissions(completion: nil)

        #expect(mockDefaults.bool(forKey: .notificationsConsentGranted))
    }

    @Test
    func requestPermissions_consentRejected_grantsConsent() {
        let mockDefaults = MockUserDefaultsService()
        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: MockUserNotificationCenter(),
            configService: MockAppConfigService(),
            userDefaults: mockDefaults
        )

        mockDefaults.set(bool: false, forKey: .notificationsConsentGranted)

        sut.requestPermissions(completion: nil)

        #expect(mockDefaults.bool(forKey: .notificationsConsentGranted))
    }

    @Test
    func requestPermissions_consentNotSet_grantsConsent() {
        let mockDefaults = MockUserDefaultsService()
        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: MockUserNotificationCenter(),
            configService: MockAppConfigService(),
            userDefaults: mockDefaults
        )

        sut.requestPermissions(completion: nil)

        #expect(mockDefaults.bool(forKey: .notificationsConsentGranted))
    }

    @Test
    func fetchConsentAlignment_consentAligned_returnsExpectedResult() async {
        let mockDefaults = MockUserDefaultsService()
        let mockUserNotificationCenter = MockUserNotificationCenter()
        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: mockUserNotificationCenter,
            configService: MockAppConfigService(),
            userDefaults: mockDefaults
        )

        mockUserNotificationCenter._stubbedAuthorizationStatus = .authorized

        mockDefaults.set(bool: true, forKey: .notificationsConsentGranted)

        let alignment = await sut.fetchConsentAlignment()

        #expect(alignment == .aligned)
    }

    @Test
    func fetchConsentAlignment_notificationsEnabled_consentNotGranted_returnsExpectedResult() async {
        let mockDefaults = MockUserDefaultsService()
        let mockUserNotificationCenter = MockUserNotificationCenter()
        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: mockUserNotificationCenter,
            configService: MockAppConfigService(),
            userDefaults: mockDefaults
        )

        mockUserNotificationCenter._stubbedAuthorizationStatus = .authorized

        mockDefaults.set(bool: false, forKey: .notificationsConsentGranted)

        let alignment = await sut.fetchConsentAlignment()

        #expect(alignment == .misaligned(.consentNotGrantedNotificationsOn))
    }

    @Test
    func fetchConsentAlignment_notificationsDisabled_consentGranted_returnsExpectedResult() async {
        let mockDefaults = MockUserDefaultsService()
        let mockUserNotificationCenter = MockUserNotificationCenter()
        let sut = NotificationService(
            environmentService: MockAppEnvironmentService(),
            notificationCenter: mockUserNotificationCenter,
            configService: MockAppConfigService(),
            userDefaults: mockDefaults
        )

        mockUserNotificationCenter._stubbedAuthorizationStatus = .denied

        mockDefaults.set(bool: true, forKey: .notificationsConsentGranted)

        let alignment = await sut.fetchConsentAlignment()

        #expect(alignment == .misaligned(.consentGrantedNotificationsOff))
    }
}
