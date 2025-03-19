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
            style: .cancel,
            handler: { _ in
                handler?()
            }
        )
    }

    static func destructive(title: String,
                            handler: (() -> Void)?) -> UIAlertAction {
        .init(
            title: title,
            style: .destructive,
            handler: { _ in
                handler?()
            }
        )
    }
}
