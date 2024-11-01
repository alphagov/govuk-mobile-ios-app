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

        return TopAlignedBarButtonItem(title: title,
                                       tint: UIColor.govUK.text.link,
                                       action: action)
    }

    static func deselectAll(action: @escaping (UIAction) -> Void) -> UIBarButtonItem {
        let title = String.recentActivity.localized("deselectAllButtonTitle")
        return TopAlignedBarButtonItem(title: title,
                                       tint: UIColor.govUK.text.link,
                                       action: action)
    }

    static func remove(action: @escaping (UIAction) -> Void) -> UIBarButtonItem {
        let title = String.recentActivity.localized("removeActivitiesButtonTitle")
        return TopAlignedBarButtonItem(title: title,
                                       tint: .red,
                                       action: action)
    }
}
