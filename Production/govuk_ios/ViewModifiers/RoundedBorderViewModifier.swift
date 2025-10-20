import SwiftUI
import UIComponents

public struct RoundedBorder: ViewModifier {
    private let cornerRadius: CGFloat
    private let borderColor: Color
    private let borderWidth: CGFloat

    public init(cornerRadius: CGFloat = 10,
                borderColor: Color = Color(UIColor.govUK.strokes.cardBlue),
                borderWidth: CGFloat = 0.5) {
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }

    public func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    borderColor,
                    lineWidth: borderWidth
                )
            )
    }
}

extension View {
    public func roundedBorder(cornerRadius: CGFloat = 10,
                              borderColor: Color = Color(UIColor.govUK.strokes.cardBlue),
                              borderWidth: CGFloat = 0.5) -> some View {
        modifier(RoundedBorder(cornerRadius: cornerRadius,
                               borderColor: borderColor,
                               borderWidth: borderWidth))
    }
}
