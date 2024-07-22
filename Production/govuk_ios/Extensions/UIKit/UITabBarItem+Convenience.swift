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
}
