import Foundation
import UIKit

extension UINavigationBar {
    public static func setGovUKAppearance(_ navBar: UINavigationBar?) {
        guard let navBar = navBar else { return }

        navBar.standardAppearance = .govUK
        navBar.scrollEdgeAppearance = .govUK
        navBar.compactAppearance = .govUK
        navBar.tintColor = UIColor.govUK.text.linkHeader
    }

    public static func setStandardAppearance(_ navBar: UINavigationBar?) {
        guard let navBar = navBar else { return }

        navBar.standardAppearance = .standard
        navBar.scrollEdgeAppearance = .standardScroll
        navBar.compactAppearance = .standard
    }
}
