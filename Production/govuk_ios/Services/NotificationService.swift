import Foundation
import UIKit
import UserNotifications
import Onboarding

import OneSignalFramework

protocol NotificationServiceInterface: OnboardingSlideProvider {
    func appDidFinishLaunching(launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    func requestPermissions(completion: @escaping () -> Void)
    var shouldRequestPermission: Bool { get async }
}

class NotificationService: NotificationServiceInterface {
    private var environmentService: AppEnvironmentServiceInterface
    private let notificationCenter: UserNotificationCenterInterface

    init(environmentService: AppEnvironmentServiceInterface,
         notificationCenter: UserNotificationCenterInterface) {
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
            await notificationCenter.authorizationStatus == .notDetermined
        }
    }

    func requestPermissions(completion: @escaping () -> Void) {
        OneSignal.setConsentGiven(true)
        OneSignal.Notifications.requestPermission({ _ in
            completion()
        }, fallbackToSettings: false)
    }

    func fetchSlides(
        completion: @escaping (Result<[any OnboardingSlideViewModelInterface], Error>) -> Void
    ) {
        let slides = [
            OnboardingSlideAnimationViewModel(
                slide: .init(
                    image: "onboarding_stay_updated",
                    title: String.notifications.localized("onboardingTitle"),
                    body: String.notifications.localized("onboardingBody"),
                    name: "NotificationsOnboardingScreen"
                ),
                primaryButtonTitle: String.notifications.localized("onboardingAcceptButtonTitle"),
                secondaryButtonTitle: String.notifications.localized("onboardingSkipButtonTitle")
            )
        ]
        completion(.success(slides))
    }
}

protocol UserNotificationCenterInterface {
    var authorizationStatus: UNAuthorizationStatus { get async }
}

extension UNUserNotificationCenter: UserNotificationCenterInterface {
    var authorizationStatus: UNAuthorizationStatus {
        get async {
            await notificationSettings().authorizationStatus
        }
    }
}
