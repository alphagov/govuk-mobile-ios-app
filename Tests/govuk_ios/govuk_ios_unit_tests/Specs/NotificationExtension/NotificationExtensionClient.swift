import Foundation
import Testing
import UserNotifications

import OneSignalExtension

@testable import govuk_ios_notification_service

@Suite(.serialized)
struct NotificationExtensionClientTests {
    @Test
    func testTest() async {
//        let service = NotificationExtensionClient()
//        let oneSignal = MockOneSignalExtension.self
//        service.oneSignal = oneSignal
//        let request = UNNotificationRequest(identifier: "", content: .init(), trigger: nil)
//        let result = await withCheckedContinuation { continuation in
//            service.didReceive(
//                request,
//                withContentHandler: { content in
//                    continuation.resume(returning: content)
//                }
//            )
//        }
//        #expect(result is UNMutableNotificationContent)
    }
}

class MockOneSignalExtension: OneSignalExtension {
    static var _didReceiveNotificationExtensionRequestCalled = false

    override class func didReceiveNotificationExtensionRequest(
        _ request: UNNotificationRequest,
        with
        replacementContent: UNMutableNotificationContent?,
        withContentHandler
        contentHandler: ((UNNotificationContent) -> Void)!
    ) -> UNMutableNotificationContent! {
        _didReceiveNotificationExtensionRequestCalled = true
        return replacementContent
    }
}
