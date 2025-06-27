import UIKit

extension GOVUKButton.ButtonConfiguration {
    public static var primary: GOVUKButton.ButtonConfiguration {
        .init(
            titleColorNormal: UIColor.govUK.text.buttonPrimary,
            titleColorHighlighted: nil,
            titleColorFocused: UIColor.govUK.text.buttonPrimaryFocussed,
            titleColorDisabled: UIColor.govUK.text.buttonPrimaryDisabled,
            titleFont: UIFont.govUK.bodySemibold,
            backgroundColorNormal: UIColor.govUK.fills.surfaceButtonPrimary,
            backgroundColorHighlighted: UIColor.govUK.fills.surfaceButtonPrimaryHighlight,
            backgroundColorFocused: UIColor.govUK.fills.surfaceButtonPrimaryFocussed,
            backgroundColorDisabled: UIColor.govUK.fills.surfaceButtonPrimaryDisabled,
            cornerRadius: 15,
            accessibilityButtonShapesColor: UIColor.grey100
        )
    }

    public static var secondary: GOVUKButton.ButtonConfiguration {
        .init(
            titleColorNormal: UIColor.govUK.text.buttonSecondary,
            titleColorHighlighted: UIColor.govUK.text.buttonSecondaryHighlight,
            titleColorFocused: UIColor.govUK.text.buttonSecondaryFocussed,
            titleColorDisabled: UIColor.govUK.text.buttonSecondaryDisabled,
            titleFont: UIFont.govUK.body,
            backgroundColorNormal: UIColor.govUK.fills.surfaceButtonSecondary,
            backgroundColorHighlighted: UIColor.govUK.fills.surfaceButtonSecondaryHighlight,
            backgroundColorFocused: UIColor.govUK.fills.surfaceButtonSecondaryFocussed,
            backgroundColorDisabled: .clear,
            accessibilityButtonShapesColor: UIColor.grey100
        )
    }

    public static var compact: GOVUKButton.ButtonConfiguration {
        .init(
            titleColorNormal: UIColor.govUK.text.buttonCompact,
            titleColorHighlighted: UIColor.govUK.text.buttonCompactHighlight,
            titleColorFocused: UIColor.govUK.text.buttonCompactFocussed,
            titleColorDisabled: UIColor.govUK.text.buttonCompactDisabled,
            titleFont: UIFont.govUK.body,
            backgroundColorNormal: UIColor.govUK.fills.surfaceButtonCompact,
            backgroundColorHighlighted: UIColor.govUK.fills.surfaceButtonCompactHighlight,
            backgroundColorFocused: UIColor.govUK.fills.surfaceButtonCompactFocussed,
            backgroundColorDisabled: UIColor.govUK.fills.surfaceButtonCompactDisabled,
            cornerRadius: 15,
            borderColorNormal: UIColor.govUK.strokes.cardBlue,
            borderColorHighlighted: UIColor.govUK.strokes.buttonCompactHighlight,
            accessibilityButtonShapesColor: UIColor.grey100
        )
    }

    public static var destructive: GOVUKButton.ButtonConfiguration {
        .init(
            titleColorNormal: UIColor.govUK.text.buttonPrimary,
            titleColorHighlighted: nil,
            titleColorFocused: UIColor.govUK.text.buttonPrimaryFocussed,
            titleColorDisabled: UIColor.govUK.text.buttonPrimaryDisabled,
            titleFont: UIFont.govUK.bodySemibold,
            backgroundColorNormal: UIColor.govUK.fills.surfaceButtonDestructive,
            backgroundColorHighlighted: UIColor.govUK.fills.surfaceButtonDestructiveHighlight,
            backgroundColorFocused: UIColor.govUK.fills.surfaceButtonPrimaryFocussed,
            backgroundColorDisabled: UIColor.govUK.fills.surfaceButtonPrimaryDisabled,
            cornerRadius: 15,
            accessibilityButtonShapesColor: UIColor.grey100
        )
    }
}
