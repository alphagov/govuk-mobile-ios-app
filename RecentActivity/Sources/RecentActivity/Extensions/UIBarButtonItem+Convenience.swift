import Foundation
import UIKit
import GOVKit

extension UIBarButtonItem {
    public static func selectAll(action: @escaping (UIAction) -> Void) -> UIBarButtonItem {
        let title = String.recentActivity.localized("selectAllButtonTitle")

        return TopAlignedBarButtonItem(title: title,
                                       tint: UIColor.govUK.text.link,
                                       action: action)
    }

    public static func deselectAll(action: @escaping (UIAction) -> Void) -> UIBarButtonItem {
        let title = String.recentActivity.localized("deselectAllButtonTitle")
        return TopAlignedBarButtonItem(title: title,
                                       tint: UIColor.govUK.text.link,
                                       action: action)
    }

    public static func remove(action: @escaping (UIAction) -> Void) -> UIBarButtonItem {
        let title = String.recentActivity.localized("removeActivitiesButtonTitle")
        return TopAlignedBarButtonItem(title: title,
                                       tint: UIColor.govUK.text.buttonDestructive,
                                       action: action)
    }
}
