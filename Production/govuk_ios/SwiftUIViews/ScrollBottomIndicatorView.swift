import SwiftUI

struct ScrollBottomIndicatorView: View {
    @State private var visibility: CGFloat = 0

    let bottomPadding = 30.0
    let imageHeight = 40.0
    let scrollViewHeight: CGFloat
    let scrollViewCoordinateSpace: String

    private var totalHeight: CGFloat {
        imageHeight + bottomPadding
    }

    var body: some View {
        GeometryReader { geometry in
            Image(decorative: "crownLogo")
                .resizable()
                .frame(width: imageHeight, height: imageHeight)
                .frame(maxWidth: .infinity)
                .opacity(visibility)
                .scaleEffect(visibility)
                .onChange(of: geometry.frame(in: .named(scrollViewCoordinateSpace)).minY,
                          perform: scrollOffsetChanged(minY:))
        }
        .frame(height: totalHeight)
    }

    private func scrollOffsetChanged(minY: CGFloat) {
        let offset = scrollViewHeight - minY
        let visibleHeight = max(0, offset)
        withAnimation {
            visibility = min(1, visibleHeight / totalHeight)
        }
    }
}
