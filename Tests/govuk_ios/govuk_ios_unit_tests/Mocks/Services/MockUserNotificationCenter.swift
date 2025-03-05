import Foundation
import UserNotifications

@testable import govuk_ios

class MockUserNotificationCenter: UserNotificationCenterInterface {


    func getAuthorisationStaus(completionHandler: @escaping (UNAuthorizationStatus) -> Void) async {
        let result = await authorizationStatus
        completionHandler(result)
    }


    var _stubbedAuthorizationStatus: UNAuthorizationStatus = .notDetermined
    open var authorizationStatus: UNAuthorizationStatus {
        get async {
            _stubbedAuthorizationStatus
        }
    }

}
