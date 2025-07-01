import Foundation
import UIKit

extension UIAlertController {
    static var deeplinkNotFoundAlert: UIAlertController {
        .generalAlert(
            title: String.deeplinks.localized("pageNotFoundAlertTitle"),
            message: String.deeplinks.localized("pageNotFoundAlertMessage"),
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
        alert.addAction(.close(handler: handler))
        return alert
    }

    static func destructiveAlert(title: String,
                                 buttonTitle: String,
                                 message: String,
                                 handler: (() -> Void)?) -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(.cancel())
        alert.addAction(.destructive(
            title: buttonTitle,
            handler: handler
        ))
        return alert
    }
}
