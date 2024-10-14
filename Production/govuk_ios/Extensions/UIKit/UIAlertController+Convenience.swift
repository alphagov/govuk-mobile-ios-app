import Foundation
import UIKit

extension UIAlertController {
    static var unhandledDeeplinkAlert: UIAlertController {
        .generalAlert(
            title: "Page not found",
            message: "Try again later.",
            handler: nil
        )
    }

    static func generalAlert(title: String,
                             message: String,
                             handler: (() -> Void)?) -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(.ok(handler: handler))
        return alert
    }

    static func clearAllRecentItems(confirmAction: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(
            title: String.recentActivity.localized("recentActivityClearAllAlertTitle"),
            message: String.recentActivity.localized("recentActivityClearAllAlertWarningDesc"),
            preferredStyle: .alert
        )
        alert.addAction(.clearAll(handler: confirmAction))
        alert.addAction(.cancel())
        return alert
    }
}
