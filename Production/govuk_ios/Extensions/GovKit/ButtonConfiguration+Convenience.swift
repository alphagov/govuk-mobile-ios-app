import Foundation
import UIKit
import UIComponents

extension GOVUKButton.ButtonConfiguration {
    public static var text: GOVUKButton.ButtonConfiguration {
        .init(
            titleColorNormal: UIColor.govUK.text.link,
            titleColorHighlighted: UIColor.govUK.text.link,
            titleColorFocused: UIColor.govUK.text.link,
            titleColorDisabled: UIColor.govUK.text.link,
            titleFont: UIFont.govUK.body,
            contentEdgeInsets: .init(top: 8, left: 0, bottom: 8, right: 0),
            backgroundColorNormal: .clear,
            backgroundColorHighlighted: .clear,
            backgroundColorFocused: .clear,
            backgroundColorDisabled: .clear,
            cornerRadius: 0,
            borderColorNormal: .clear,
            borderColorHighlighted: .clear,
            accessibilityButtonShapesColor: .blue,
            shadowColor: UIColor.clear.cgColor,
            shadowRadius: 0,
            shadowHighLightedColor: UIColor.clear.cgColor,
            shadowFocusedColor: UIColor.clear.cgColor
        )
    }
}
