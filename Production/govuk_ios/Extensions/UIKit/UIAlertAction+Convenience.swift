import Foundation
import UIKit

extension UIAlertAction {
    static func ok(handler: (() -> Void)?) -> UIAlertAction {
        .init(
            title: String.common.localized("ok"),
            style: .default,
            handler: { _ in
                handler?()
            }
        )
    }
}
