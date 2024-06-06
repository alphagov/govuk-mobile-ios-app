import UIKit
import Foundation

class NavigationController: UINavigationController {
    private var notificationCenter: NotificationCenter = .default

    private var standardAppearance: UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.largeTitleTextAttributes = largeTitleTextAttributes
        return appearance
    }

    private var largeTitleTextAttributes: [NSAttributedString.Key: Any] {
        return [
            .font: UIFont.govuk.header1.font
        ]
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        registerNotifications()
        updateFont()
    }

    required init?(coder aDecoder: NSCoder) {
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
        navigationBar.standardAppearance = standardAppearance
        navigationBar.largeTitleTextAttributes = largeTitleTextAttributes
    }
}
