import Foundation
import UIKit

extension UIAlertController {
    static var unhandledDeeplinkAlert: UIAlertController {
        .generalAlert(
            title: "Page not found",
            message: "Try again later.",
            handler: nil
        )
    }

    static func generalAlert(title: String,
                             message: String,
                             handler: (() -> Void)?) -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(.ok(handler: handler))
        return alert
    }

    static func clearAllRecentItems(confirmAction: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(
            title: "Clear pages you’ve visited?",
            message: "Permanently clear the list of all pages you’ve visited",
            preferredStyle: .alert
        )
        alert.addAction(.clearAll(handler: confirmAction))
        alert.addAction(.cancel())
        return alert
//        alert.addAction(.init(title: "OK", style: .default, handler: { [weak self] _ in
//            self?.viewModel.deleteAllItems()
//            self?.reloadSnapshot()
//        }))
    }
}
