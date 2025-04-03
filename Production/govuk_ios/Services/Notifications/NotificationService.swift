import Foundation
import UIKit
import UserNotifications
import Onboarding

import OneSignalFramework

protocol NotificationServiceInterface: OnboardingSlideProvider {
    func appDidFinishLaunching(launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    func requestPermissions(completion: (() -> Void)?)
    var shouldRequestPermission: Bool { get async }
    var authorizationStatus: NotificationPermissionState { get async }
    var isFeatureEnabled: Bool { get }
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

    var authorizationStatus: NotificationPermissionState {
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
                await authorizationStatus == .notDetermined
            )
            return switches.0 && switches.1
        }
    }

    var isFeatureEnabled: Bool {
        true
    }

    func requestPermissions(completion: (() -> Void)?) {
        OneSignal.setConsentGiven(true)
        OneSignal.Notifications.requestPermission({ _ in
            completion?()
        }, fallbackToSettings: false)
    }

    func fetchSlides(
        completion: @escaping (Result<[any OnboardingSlideViewModelInterface], Error>) -> Void
    ) {
        completion(.success(Onboarding.notificationSlides))
    }
}
