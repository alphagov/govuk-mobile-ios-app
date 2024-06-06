import UIKit
import Foundation

extension UITabBarItem {
    static var red: UITabBarItem {
        let test = UITabBarItem(
            title: "Red",
            image: nil,
            selectedImage: nil
        )
        return test
    }

    static var blue: UITabBarItem {
        .init(
            title: "Blue",
            image: nil,
            selectedImage: nil
        )
    }

    static var green: UITabBarItem {
        .init(
            title: "Green",
            image: nil,
            selectedImage: nil
        )
    }
}
