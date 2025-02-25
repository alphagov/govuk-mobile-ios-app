import Foundation
import UserNotifications

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
