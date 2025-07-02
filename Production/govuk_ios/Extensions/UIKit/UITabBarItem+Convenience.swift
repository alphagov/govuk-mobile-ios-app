import UIKit
import Foundation

extension UITabBarItem {
    static var home: UITabBarItem {
        .init(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: nil
        )
    }

    static var settings: UITabBarItem {
        .init(
            title: "Settings",
            image: UIImage(systemName: "gearshape"),
            selectedImage: nil
        )
    }

    static var chat: UITabBarItem {
        .init(
            title: "Chat",
            image: UIImage(named: "chat_icon"),
            selectedImage: UIImage(named: "chat_icon_selected")
        )
    }
}
