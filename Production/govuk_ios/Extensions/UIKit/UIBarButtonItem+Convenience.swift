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

    static func recentActivitEdit(target: Any,
                                  action: Selector) -> UIBarButtonItem {
        UIBarButtonItem(
            title: String.recentActivity.localized("editButtonTitle"),
            style: .plain,
            target: target,
            action: action
        )
    }
}
