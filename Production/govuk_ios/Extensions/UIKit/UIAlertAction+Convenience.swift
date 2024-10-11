import Foundation
import UIKit

extension UIAlertAction {
    static func ok(handler: (() -> Void)?) -> UIAlertAction {
        .init(
            title: "OK",
            style: .default,
            handler: { _ in
                handler?()
            }
        )
    }

    static func cancel(handler: (() -> Void)? = nil) -> UIAlertAction {
        .init(
            title: "Cancel",
            style: .default,
            handler: { _ in
                handler?()
            }
        )
    }

    static func clearAll(handler: (() -> Void)? = nil) -> UIAlertAction {
        .init(
            title: "Clear all",
            style: .destructive,
            handler: { _ in
                handler?()
            }
        )
    }
}
