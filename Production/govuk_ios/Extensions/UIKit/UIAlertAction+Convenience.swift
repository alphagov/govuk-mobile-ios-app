import Foundation
import UIKit

extension UIAlertAction {
    static func ok(handler: (() -> Void)?) -> UIAlertAction {
        .init(
            title: String.common.localized("ok"),
            style: .default,
            handler: { _ in
                handler?()
            }
        )
    }

    static func cancel(handler: (() -> Void)? = nil) -> UIAlertAction {
        .init(
            title: String.common.localized("cancel"),
            style: .default,
            handler: { _ in
                handler?()
            }
        )
    }

    static func clearAll(handler: (() -> Void)? = nil) -> UIAlertAction {
        .init(
            title: String.recentActivity.localized("clearAllActionTitle"),
            style: .destructive,
            handler: { _ in
                handler?()
            }
        )
    }
}
