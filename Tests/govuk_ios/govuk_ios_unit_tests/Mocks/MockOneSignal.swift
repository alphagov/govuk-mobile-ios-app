import Foundation
import UIKit

import OneSignalFramework

@testable import govuk_ios

class MockOneSignal: OneSignalInterface {
    static func setConsentRequired(_ required: Bool) {

    }
    
    static func initialize(appId: String,
                           launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {

    }
    
    static func setConsentGiven(_ given: Bool) {

    }
    
    static var Notifications: any OSNotifications.Type {
        MockOSNotifications.self
    }

}


class MockOSNotifications: NSObject,
                           OSNotifications {
    static func __permission() -> Bool {
        return true
    }

    static func __canRequestPermission() -> Bool {
        return true
    }

    static func __permissionNative() -> OSNotificationPermission {
        return .authorized
    }

    static func addForegroundLifecycleListener(_ listener: (any OSNotificationLifecycleListener)?) {

    }

    static func removeForegroundLifecycleListener(_ listener: (any OSNotificationLifecycleListener)?) {

    }

    static func __add(_ listener: any OSNotificationClickListener) {

    }

    static func __remove(_ listener: any OSNotificationClickListener) {

    }

    static func requestPermission(_ block: OSUserResponseBlock? = nil) {

    }

    static func requestPermission(_ block: OSUserResponseBlock?, fallbackToSettings fallback: Bool) {

    }

    static func __register(forProvisionalAuthorization block: OSUserResponseBlock? = nil) {

    }

    static func __add(_ observer: any OSNotificationPermissionObserver) {

    }

    static func __remove(_ observer: any OSNotificationPermissionObserver) {

    }

    static func clearAll() {

    }
}
