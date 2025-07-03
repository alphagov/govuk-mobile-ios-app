import SwiftUI

public struct AdaptiveStack<Content: View>: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    let horizontalAlignment: HorizontalAlignment
    let verticalAlignment: VerticalAlignment
    let content: () -> Content

    public init(horizontalAlignment: HorizontalAlignment = .center,
                verticalAlignment: VerticalAlignment = . center,
                @ViewBuilder content: @escaping () -> Content) {
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.content = content
    }

    public var body: some View {
        Group {
            if verticalSizeClass == .compact {
                HStack(alignment: verticalAlignment, content: content)
            } else {
                VStack(alignment: horizontalAlignment, content: content)
            }
        }
    }
}
