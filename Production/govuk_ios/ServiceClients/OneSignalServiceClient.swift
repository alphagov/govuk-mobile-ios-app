import Foundation

import OneSignalFramework

protocol OneSignalServiceClient: AnyObject {
    static func setConsentRequired(_ required: Bool)
    static func initialize(appId: String,
                           launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    static func setConsentGiven(_ given: Bool)

    static var Notifications: any OSNotifications.Type { get }
}

extension OneSignal: OneSignalServiceClient {
    static func initialize(appId: String,
                           launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        initialize(appId, withLaunchOptions: launchOptions)
    }
}
