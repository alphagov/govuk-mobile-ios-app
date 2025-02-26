import Foundation
import UIKit

protocol NotificationAuthorisationInterface {
    var notificationsPermissionState: NotificationPermissionState { get set }
}

class NotificationsAuthStatus: NotificationAuthorisationInterface {
    var notificationsPermissionState: NotificationPermissionState = .notDetermined
    let notificationsSettings = UNUserNotificationCenter.current()

    init() {
        checkNotificationPermissionStatus()
    }

    private func checkNotificationPermissionStatus() {
        notificationsSettings.getNotificationSettings(completionHandler: { [weak self] (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                self?.notificationsPermissionState = .authorized
            case .denied:
                self?.notificationsPermissionState = .denied
            default:
                self?.notificationsPermissionState = .notDetermined
            }
        })
    }
}
