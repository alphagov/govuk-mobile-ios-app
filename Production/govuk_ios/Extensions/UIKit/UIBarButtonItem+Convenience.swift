import Foundation
import UIKit

extension UIBarButtonItem {
    static func cancel(target: Any,
                       action: Selector) -> UIBarButtonItem {
        UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: target,
            action: action
        )
    }

    static func clearAll(target: Any,
                         action: Selector) -> UIBarButtonItem {
        UIBarButtonItem(
            title: "Clear All",
            style: .plain,
            target: target,
            action: action
        )
    }
}
