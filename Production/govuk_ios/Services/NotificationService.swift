import Foundation
import UIKit

import OneSignalFramework

protocol NotificationServiceInterface {
    func appDidFinishLaunching(launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
}

class NotificationService: NotificationServiceInterface {
    private var environmentService: AppEnvironmentServiceInterface

    init(environmentService: AppEnvironmentServiceInterface) {
        self.environmentService = environmentService
    }

    func appDidFinishLaunching(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        OneSignal.initialize(
            environmentService.oneSignalAppId,
            withLaunchOptions: launchOptions
        )

        OneSignal.Notifications.requestPermission({ accepted in
            print("User accepted notifications: \(accepted)")
        }, fallbackToSettings: false)
    }
}
