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
}
