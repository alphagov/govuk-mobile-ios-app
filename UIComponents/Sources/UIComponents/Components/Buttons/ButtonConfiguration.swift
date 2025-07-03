import UIKit

extension GOVUKButton {
    public struct ButtonConfiguration {
        let titleColorNormal: UIColor?
        let titleColorHighlighted: UIColor?
        let titleColorFocused: UIColor?
        let titleColorDisabled: UIColor?

        let titleFont: UIFont
        let textAlignment: NSTextAlignment
        let contentHorizontalAlignment: UIControl.ContentHorizontalAlignment
        let contentVerticalAlignment: UIControl.ContentVerticalAlignment
        let contentEdgeInsets: UIEdgeInsets

        let backgroundColorNormal: UIColor
        let backgroundColorHighlighted: UIColor
        let backgroundColorFocused: UIColor
        let backgroundColorDisabled: UIColor
        let cornerRadius: CGFloat

        let borderColorNormal: UIColor
        let borderColorHighlighted: UIColor

        let accessibilityButtonShapesColor: UIColor

        public init(titleColorNormal: UIColor? = nil,
                    titleColorHighlighted: UIColor? = nil,
                    titleColorFocused: UIColor? = nil,
                    titleColorDisabled: UIColor? = nil,
                    titleFont: UIFont,
                    textAlignment: NSTextAlignment = .center,
                    contentHorizontalAlignment: UIControl.ContentHorizontalAlignment = .center,
                    contentVerticalAlignment: UIControl.ContentVerticalAlignment = .center,
                    contentEdgeInsets: UIEdgeInsets = defaultContentEdgeInsets,
                    backgroundColorNormal: UIColor,
                    backgroundColorHighlighted: UIColor,
                    backgroundColorFocused: UIColor,
                    backgroundColorDisabled: UIColor,
                    cornerRadius: CGFloat = 4,
                    borderColorNormal: UIColor = .clear,
                    borderColorHighlighted: UIColor = .clear,
                    accessibilityButtonShapesColor: UIColor) {
            self.titleColorNormal = titleColorNormal
            self.titleColorHighlighted = titleColorHighlighted
            self.titleColorFocused = titleColorFocused
            self.titleColorDisabled = titleColorDisabled
            self.titleFont = titleFont
            self.textAlignment = textAlignment
            self.contentHorizontalAlignment = contentHorizontalAlignment
            self.contentVerticalAlignment = contentVerticalAlignment
            self.contentEdgeInsets = contentEdgeInsets
            self.backgroundColorNormal = backgroundColorNormal
            self.backgroundColorHighlighted = backgroundColorHighlighted
            self.backgroundColorFocused = backgroundColorFocused
            self.backgroundColorDisabled = backgroundColorDisabled
            self.borderColorNormal = borderColorNormal
            self.borderColorHighlighted = borderColorHighlighted
            self.cornerRadius = cornerRadius
            self.accessibilityButtonShapesColor = accessibilityButtonShapesColor
        }
    }

    public static var defaultContentEdgeInsets: UIEdgeInsets {
        .init(
            top: 13,
            left: 16,
            bottom: 13,
            right: 16
        )
    }
}

#if DEBUG
extension GOVUKButton.ButtonConfiguration {
    @MainActor
    public static var mockConfig: Self {
        let config = GOVUKButton.ButtonConfiguration(
            titleColorNormal: .magenta,
            titleColorFocused: .green,
            titleFont: UIFont.govUK.title3,
            backgroundColorNormal: .green,
            backgroundColorHighlighted: .green.withAlphaComponent(0.7),
            backgroundColorFocused: .cyan,
            backgroundColorDisabled: .blue,
            cornerRadius: 5,
            accessibilityButtonShapesColor: .grey100
        )
        return config
    }
}
#endif

extension GOVUKButton.ButtonConfiguration {
    func backgroundColor(for state: UIControl.State) -> UIColor {
        selectedColorForState(
            state: state,
            highlighted: backgroundColorHighlighted,
            focussed: backgroundColorFocused,
            other: backgroundColorNormal
        )
    }

    func accessibilityButtonShapesColor(for state: UIControl.State) -> UIColor {
        guard backgroundColorNormal == .clear
        else { return backgroundColor(for: state) }
        return selectedColorForState(
            state: state,
            highlighted: accessibilityButtonShapesColor.withAlphaComponent(0.7),
            focussed: accessibilityButtonShapesColor,
            other: accessibilityButtonShapesColor
        )
    }

    private func selectedColorForState(state: UIControl.State,
                                       highlighted: UIColor,
                                       focussed: UIColor,
                                       other: UIColor) -> UIColor {
        if state.contains(.highlighted) {
            return highlighted
        } else if state.contains(.focused) {
            return focussed
        } else {
            return other
        }
    }
}
