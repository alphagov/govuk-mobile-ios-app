import UIKit
import Foundation

class Font {
    static func test(style: UIFont.TextStyle) -> UIFont {
        let customFont = UIFont(name: "Merriweather-Regular", size: 17)!
        return UIFontMetrics(
            forTextStyle: style
        ).scaledFont(
            for: customFont
        )
    }
}
