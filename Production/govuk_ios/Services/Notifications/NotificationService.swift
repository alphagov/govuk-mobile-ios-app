import Foundation
import UIKit
import UserNotifications

import OneSignalFramework

protocol NotificationServiceInterface {
    func appDidFinishLaunching(launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    func requestPermissions(completion: (() -> Void)?)
    func addClickListener(onClickAction: @escaping (URL) -> Void)
    func acceptConsent()
    func rejectConsent()
    func toggleHasGivenConsent()
    var shouldRequestPermission: Bool { get async }
    var permissionState: NotificationPermissionState { get async }
    var isFeatureEnabled: Bool { get }
    func fetchConsentAlignment() async -> NotificationConsentResult
}

class NotificationService: NSObject,
                           NotificationServiceInterface,
                           OSNotificationClickListener {
    private var environmentService: AppEnvironmentServiceInterface
    private let notificationCenter: UserNotificationCenterInterface
    private let configService: AppConfigServiceInterface
    private let userDefaultsService: UserDefaultsServiceInterface
    private let oneSignalType: OneSignalInterface.Type
    var onClickAction: ((URL) -> Void)?

    init(environmentService: AppEnvironmentServiceInterface,
         notificationCenter: UserNotificationCenterInterface,
         configService: AppConfigServiceInterface,
         userDefaultsService: UserDefaultsServiceInterface,
         oneSignalInterface: OneSignalInterface.Type) {
        self.environmentService = environmentService
        self.notificationCenter = notificationCenter
        self.configService = configService
        self.userDefaultsService = userDefaultsService
        self.oneSignalType = oneSignalInterface
    }

    func appDidFinishLaunching(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        oneSignalType.setConsentGiven(true)
        oneSignalType.initialize(
            appId: environmentService.oneSignalAppId,
            launchOptions: launchOptions
        )
    }

    var permissionState: NotificationPermissionState {
        get async {
            let localStatus = await notificationCenter.authorizationStatus
            switch localStatus {
            case .authorized:
                return .authorized
            case .denied:
                return .denied
            case .notDetermined, .ephemeral, .provisional:
                return .notDetermined
            @unknown default:
                return .notDetermined
            }
        }
    }

    var shouldRequestPermission: Bool {
        get async {
            let switches = (
                isFeatureEnabled,
                await permissionState == .notDetermined
            )
            return switches.0 && switches.1
        }
    }

    var isFeatureEnabled: Bool {
        configService.isFeatureEnabled(key: .notifications)
    }

    private var hasGivenConsent: Bool {
        userDefaultsService.bool(forKey: .notificationsConsentGranted)
    }

    func acceptConsent() {
        updateConsent(given: true)
    }

    func rejectConsent() {
        updateConsent(given: false)
    }

    func toggleHasGivenConsent() {
        var permission = hasGivenConsent
        permission.toggle()
        updateConsent(given: permission)
    }

    private func updateConsent(given: Bool) {
        userDefaultsService.set(bool: given, forKey: .notificationsConsentGranted)
        oneSignalType.setConsentGiven(given)
    }

    func requestPermissions(completion: (() -> Void)?) {
        updateConsent(given: true)
        oneSignalType.Notifications.requestPermission({ [weak self] accepted in
            self?.updateConsent(given: accepted)
            completion?()
        }, fallbackToSettings: false)
    }

    func addClickListener(onClickAction: @escaping (URL) -> Void) {
        oneSignalType.Notifications.addClickListener(self)
        self.onClickAction = onClickAction
    }

    func onClick(event: OSNotificationClickEvent) {
        handleAdditionalData(event.notification.additionalData)
    }

    func handleAdditionalData(_ additionalData: [AnyHashable: Any]?) {
        guard let additionalData,
              let deeplinkStr = additionalData["deeplink"] as? String,
              let deeplink = URL(string: deeplinkStr)
        else { return }
        onClickAction?(deeplink)
    }

    func fetchConsentAlignment() async -> NotificationConsentResult {
        let isSubscribed = await permissionState == .authorized
        switch (hasGivenConsent, isSubscribed) {
        case (true, false):
            return .misaligned(.consentGrantedNotificationsOff)
        case (false, true):
            return .misaligned(.consentNotGrantedNotificationsOn)
        default:
            return .aligned
        }
    }
}

enum NotificationConsentResult: Equatable {
    case aligned
    case misaligned(NotificationConsentMisalignment)
}

enum NotificationConsentMisalignment: Equatable {
    case consentNotGrantedNotificationsOn
    case consentGrantedNotificationsOff
}

protocol OneSignalInterface: AnyObject {
    static func setConsentRequired(_ required: Bool)
    static func initialize(appId: String,
                           launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    static func setConsentGiven(_ given: Bool)

    static var Notifications: any OSNotifications.Type { get }
}

extension OneSignal: OneSignalInterface {
    static func initialize(appId: String,
                           launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        initialize(appId, withLaunchOptions: launchOptions)
    }
}
