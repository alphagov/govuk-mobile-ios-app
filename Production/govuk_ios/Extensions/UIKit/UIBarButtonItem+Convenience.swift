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

    static func selectAll(target: Any,
                          action: Selector) -> UIBarButtonItem {
        let item = UIBarButtonItem(
            title: "Select all",
            style: .plain,
            target: target,
            action: action
        )
        item.tintColor = UIColor.govUK.text.link
        return item
    }

    static func remove(target: Any,
                       action: Selector) -> UIBarButtonItem {
        let item = UIBarButtonItem(
            title: "Remove",
            style: .plain,
            target: target,
            action: action
        )
        item.tintColor = .red
        return item
    }
}
