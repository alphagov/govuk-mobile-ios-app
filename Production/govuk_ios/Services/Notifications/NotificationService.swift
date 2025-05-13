import Foundation
import UIKit
import UserNotifications
import Onboarding

import OneSignalFramework

protocol NotificationServiceInterface: OnboardingSlideProvider {
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
    private let userDefaults: UserDefaultsInterface
    var onClickAction: ((URL) -> Void)?

    init(environmentService: AppEnvironmentServiceInterface,
         notificationCenter: UserNotificationCenterInterface,
         userDefaults: UserDefaultsInterface) {
        self.environmentService = environmentService
        self.notificationCenter = notificationCenter
        self.userDefaults = userDefaults
    }

    func appDidFinishLaunching(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        OneSignal.setConsentRequired(true)
        OneSignal.initialize(
            environmentService.oneSignalAppId,
            withLaunchOptions: launchOptions
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
        false
    }

    private var hasGivenConsent: Bool {
        userDefaults.bool(forKey: .notificationsConsentGranted)
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
        userDefaults.set(bool: given, forKey: .notificationsConsentGranted)
        OneSignal.setConsentGiven(given)
    }

    func requestPermissions(completion: (() -> Void)?) {
        updateConsent(given: true)
        OneSignal.Notifications.requestPermission({ [weak self] accepted in
            self?.updateConsent(given: accepted)
            completion?()
        }, fallbackToSettings: false)
    }

    func fetchSlides(
        completion: @escaping (Result<[any OnboardingSlideViewModelInterface], Error>) -> Void
    ) {
        completion(.success(Onboarding.notificationSlides))
    }

    func addClickListener(onClickAction: @escaping (URL) -> Void) {
        OneSignal.Notifications.addClickListener(self)
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
