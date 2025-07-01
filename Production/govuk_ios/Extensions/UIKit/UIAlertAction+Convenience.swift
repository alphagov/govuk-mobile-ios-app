import Foundation
import UIKit

extension UIAlertAction {
    static func close(handler: (() -> Void)?) -> UIAlertAction {
        .init(
            title: String.common.localized("close"),
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

    static func continueAction(handler: (() -> Void)? = nil) -> UIAlertAction {
        .init(
            title: String.common.localized("continue"),
            style: .default,
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
