import UIKit
import GOVKit

extension UIApplication: @retroactive URLOpener {
    @discardableResult
    public func openIfPossible(_ url: URL) -> Bool {
        guard canOpenURL(url)
        else { return false }
        open(url, options: [:], completionHandler: nil)
        return true
    }
}

extension URLOpener {
    @discardableResult
    public func openSettings() -> Bool {
        openIfPossible(UIApplication.openSettingsURLString)
    }

    @discardableResult
    public func openNotificationSettings() -> Bool {
        openIfPossible(UIApplication.openNotificationSettingsURLString)
    }
}
