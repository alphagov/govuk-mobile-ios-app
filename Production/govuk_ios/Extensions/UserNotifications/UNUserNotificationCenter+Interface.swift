import Foundation
import UserNotifications

protocol UserNotificationCenterInterface {
    var authorizationStatus: UNAuthorizationStatus { get async }
    func returnAuthorisationStatus(completionHandler: @escaping (UNNotificationSettings) -> Void)
}

extension UNUserNotificationCenter: UserNotificationCenterInterface {
    var authorizationStatus: UNAuthorizationStatus {
        get async {
            await notificationSettings().authorizationStatus
        }
    }

    func returnAuthorisationStatus(
        completionHandler: @escaping (UNNotificationSettings) -> Void) {
        getNotificationSettings(completionHandler: completionHandler)
    }
}
