import Foundation
import UIKit
import GOVKit

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
        TopAlignedBarButtonItem(
            title: String.recentActivity.localized("selectAllButtonTitle"),
            tint: UIColor.govUK.text.link,
            action: action
        )
    }

    static func deselectAll(action: @escaping (UIAction) -> Void) -> UIBarButtonItem {
        TopAlignedBarButtonItem(
            title: String.recentActivity.localized("deselectAllButtonTitle"),
            tint: UIColor.govUK.text.link,
            action: action
        )
    }

    static func remove(action: @escaping (UIAction) -> Void) -> UIBarButtonItem {
        TopAlignedBarButtonItem(
            title: String.recentActivity.localized("removeActivitiesButtonTitle"),
            tint: UIColor.govUK.text.buttonDestructive,
            action: action
        )
    }
}

