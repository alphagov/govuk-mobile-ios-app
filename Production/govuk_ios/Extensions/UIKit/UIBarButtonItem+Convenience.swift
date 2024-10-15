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

    static func selectAll(action: @escaping (UIAction) -> Void) -> UIBarButtonItem {
        let title = String.recentActivity.localized("selectAllButtonTitle")
        let item = UIBarButtonItem(
            title: title,
            primaryAction: .init(title: title, handler: action)
        )
        item.tintColor = UIColor.govUK.text.link
        return item
    }

    static func remove(action: @escaping (UIAction) -> Void) -> UIBarButtonItem {
        let title = String.recentActivity.localized("removeActivitiesButtonTitle")
        let item = UIBarButtonItem(
            title: title,
            primaryAction: .init(title: title, handler: action)
        )
        item.tintColor = .red
        return item
    }
}
