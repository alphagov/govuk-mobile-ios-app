import Foundation
import UserNotifications

protocol UserNotificationCenterInterface {
    var authorizationStatus: UNAuthorizationStatus { get async }
    func getAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void)
}

extension UNUserNotificationCenter: UserNotificationCenterInterface {
    var authorizationStatus: UNAuthorizationStatus {
        get async {
            await notificationSettings().authorizationStatus
        }
    }

    func getAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
            Task {
                let status = await self.authorizationStatus
                completion(status)
            }
    }
}
