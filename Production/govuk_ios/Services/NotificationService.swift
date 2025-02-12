import Foundation
import UIKit
import UserNotifications
import Onboarding

import OneSignalFramework

protocol NotificationServiceInterface {
    func appDidFinishLaunching(launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    func requestPermissions(completion: @escaping () -> Void)
    var shouldRequestPermission: Bool { get async }
    func fetchSlides() -> [OnboardingSlide]
}

class NotificationService: NotificationServiceInterface {
    private var environmentService: AppEnvironmentServiceInterface
    private let notificationCenter: UNUserNotificationCenter

    init(environmentService: AppEnvironmentServiceInterface,
         notificationCenter: UNUserNotificationCenter) {
        self.environmentService = environmentService
        self.notificationCenter = notificationCenter
    }

    func appDidFinishLaunching(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        OneSignal.setConsentRequired(true)
        OneSignal.initialize(
            environmentService.oneSignalAppId,
            withLaunchOptions: launchOptions
        )
    }

    var shouldRequestPermission: Bool {
        get async {
            await notificationCenter.notificationSettings().authorizationStatus == .notDetermined
        }
    }

    func requestPermissions(completion: @escaping () -> Void) {
        OneSignal.setConsentGiven(true)
        OneSignal.Notifications.requestPermission({ _ in
            completion()
        }, fallbackToSettings: false)
    }

    func fetchSlides() -> [OnboardingSlide] {
        return [
            .init(
                image: "onboarding_screen_1",
                title: String.notifications.localized("onboardingTitle"),
                body: String.notifications.localized("onboardingBody"),
                name: "Notifications_A"
            )
        ]
    }
}
