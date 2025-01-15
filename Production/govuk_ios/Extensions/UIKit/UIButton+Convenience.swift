import Foundation
import UIKit

extension UIButton {
    static func body(title: String,
                     accessibilityLabel: String? = nil,
                     action: @escaping () -> Void) -> UIButton {
        let configuration = UIButton.Configuration.plain()
        let button = UIButton(configuration: configuration)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.govUK.body
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.addAction(
            .init(handler: { _ in action() }),
            for: .touchUpInside
        )
        button.tintColor = UIColor.govUK.text.link
        if let accessibilityLabel {
            button.accessibilityLabel = accessibilityLabel
        }
        return button
    }
}
