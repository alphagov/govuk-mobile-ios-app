import Foundation
import UIKit

extension UIBarButtonItem {
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