import UIKit
import Foundation

class TabBarController: UITabBarController {
    private var notificationCenter: NotificationCenter = .default
    private var standardAppearance: UITabBarAppearance {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = titleTextAttributes
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = titleTextAttributes
        return appearance
    }
    private var titleTextAttributes: [NSAttributedString.Key: Any] {
        return [
            .font: UIFont.govuk.tab.font
        ]
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        registerNotifications()
        updateAppearance()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func registerNotifications() {
        notificationCenter.addObserver(
            self,
            selector: #selector(updateAppearance),
            name: UIAccessibility.boldTextStatusDidChangeNotification,
            object: nil
        )
    }

    @objc
    private func updateAppearance() {
        tabBar.standardAppearance = standardAppearance
    }
}
