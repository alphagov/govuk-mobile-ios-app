import Foundation
import UIKit

class Label: UILabel {
    private var notificationCenter: NotificationCenter = .default

    var dynamicFont: GovUKFont? {
        didSet {
            self.font = dynamicFont?.scaled ?? font
        }
    }

    init() {
        super.init(frame: .zero)
        registerNotifications()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func registerNotifications() {
        notificationCenter.addObserver(
            self,
            selector: #selector(updateFont),
            name: UIAccessibility.boldTextStatusDidChangeNotification,
            object: nil
        )
    }

    @objc
    private func updateFont() {
        self.font = self.dynamicFont?.scaled ?? self.font
    }
}
