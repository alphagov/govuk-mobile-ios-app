import Foundation
import UserNotifications

import OneSignalExtension

class NotificationExtensionClient {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    var receivedRequest: UNNotificationRequest!
    var oneSignal: OneSignalExtension.Type = OneSignalExtension.self

    func didReceive(_ request: UNNotificationRequest,
                    withContentHandler
                    contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.receivedRequest = request
        self.contentHandler = contentHandler
        self.bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        if let bestAttemptContent = bestAttemptContent {
            oneSignal.didReceiveNotificationExtensionRequest(
                self.receivedRequest,
                with: bestAttemptContent,
                withContentHandler: contentHandler
            )
        }
    }

    func serviceExtensionTimeWillExpire() {
        guard let contentHandler = contentHandler,
              let bestAttemptContent =  bestAttemptContent
        else { return }
        oneSignal.serviceExtensionTimeWillExpireRequest(
            self.receivedRequest,
            with: bestAttemptContent
        )
        contentHandler(bestAttemptContent)
    }
}
