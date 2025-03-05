import Foundation
import UserNotifications

protocol UserNotificationCenterInterface {
    var authorizationStatus: UNAuthorizationStatus { get async }
    func getAuthorisationStaus(
        completionHandler: @escaping (UNAuthorizationStatus) -> Void) async
}

extension UNUserNotificationCenter: UserNotificationCenterInterface {
    var authorizationStatus: UNAuthorizationStatus {
        get async {
            await notificationSettings().authorizationStatus
        }
    }

    func getAuthorisationStaus(
        completionHandler: @escaping (UNAuthorizationStatus) -> Void) async {
        let settings = await self.authorizationStatus
            completionHandler(settings)
    }
}
