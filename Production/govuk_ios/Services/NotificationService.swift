import Foundation
import UIKit
import UserNotifications
import Onboarding

import OneSignalFramework

protocol NotificationServiceInterface: OnboardingSlideProvider {
    func appDidFinishLaunching(launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    func requestPermissions(completion: @escaping () -> Void)
    var shouldRequestPermission: Bool { get async }
    var isFeatureEnabled: Bool { get }
    func getAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void)
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

    func getAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        notificationCenter.getAuthorizationStatus(completion: completion)
    }

    var shouldRequestPermission: Bool {
        get async {
            let switches = (
                isFeatureEnabled,
                await notificationCenter.authorizationStatus == .notDetermined
            )
            return switches.0 && switches.1
        }
    }

    var isFeatureEnabled: Bool {
        false
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
        completion(.success(Onboarding.notificationSlides))
    }
}
