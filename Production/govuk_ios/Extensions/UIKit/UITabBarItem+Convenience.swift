import UIKit
import Foundation

extension UITabBarItem {
    static var home: UITabBarItem {
        let item = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: nil
        )
        return item
    }

    static var settings: UITabBarItem {
        .init(
            title: "Settings",
            image: UIImage(systemName: "gearshape"),
            selectedImage: nil
        )
    }
}
