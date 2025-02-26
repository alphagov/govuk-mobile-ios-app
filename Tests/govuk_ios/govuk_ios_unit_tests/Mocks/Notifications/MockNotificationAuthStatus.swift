import Foundation

@testable import govuk_ios

struct MockNotificationAuthStatus: NotificationAuthorisationInterface {
    var notificationsPermissionState: NotificationPermissionState = .authorized
}
