import SwiftUI

struct OverscrollIndicatorView: View {
    @State private var overscroll: CGFloat = 0

    let scrollThreshold = 10.0
    let maxHeight = 40.0
    let scrollViewHeight: CGFloat
    let scrollViewCoordinateSpace: String

    private var height: CGFloat {
        return min(overscroll, maxHeight)
    }

    private var opacity: CGFloat {
        return height/maxHeight
    }

    var body: some View {
        GeometryReader { geometry in
            Image(decorative: "crownLogo")
                .resizable()
                .frame(width: height, height: height)
                .frame(maxWidth: .infinity, alignment: .center)
                .opacity(opacity)
                .onChange(of:
                            geometry.frame(in: .named(scrollViewCoordinateSpace)).maxY,
                          perform: { maxY in
                    let scrollOffset = scrollViewHeight - maxY - scrollThreshold
                    let positiveOffset = max(0, scrollOffset)
                    overscroll = positiveOffset
                })
        }
    }
}
