import Foundation
import SwiftUI

struct AdaptiveStack<Content: View>: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    let spacing: CGFloat
    let horizontalAlignment: HorizontalAlignment
    let verticalAlignment: VerticalAlignment
    let content: () -> Content

    init(spacing: CGFloat,
         horizontalAlignment: HorizontalAlignment = .center,
         verticalAlignment: VerticalAlignment = . center,
         @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.content = content
    }

    var body: some View {
        Group {
            if  verticalSizeClass == .compact {
                HStack(alignment: verticalAlignment, content: content)
            } else {
                VStack(alignment: horizontalAlignment, content: content)
            }
        }
    }
}
