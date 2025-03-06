import Foundation
import UserNotifications

@testable import govuk_ios

class MockUserNotificationCenter: UserNotificationCenterInterface {

    var  _receivedGetAuthorizationStatusCompletion: ((UNAuthorizationStatus) -> Void)?
    func getAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        _receivedGetAuthorizationStatusCompletion = completion
    }


    var _stubbedAuthorizationStatus: UNAuthorizationStatus = .notDetermined
    open var authorizationStatus: UNAuthorizationStatus {
        get async {
            _stubbedAuthorizationStatus
        }
    }

}
