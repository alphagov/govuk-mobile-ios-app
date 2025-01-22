import Foundation
import UserNotifications

import OneSignalExtension

class NotificationServiceExtension: UNNotificationServiceExtension {
    lazy var client: NotificationExtensionClient = NotificationExtensionClient()

    override func didReceive(_ request: UNNotificationRequest,
                             withContentHandler
                             contentHandler: @escaping (UNNotificationContent) -> Void) {
        client.didReceive(request, withContentHandler: contentHandler)
    }

    override func serviceExtensionTimeWillExpire() {
        client.serviceExtensionTimeWillExpire()
    }
}
