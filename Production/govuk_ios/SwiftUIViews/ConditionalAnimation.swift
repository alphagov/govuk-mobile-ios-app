import SwiftUI

struct ConditionalAnimation<V: Equatable>: ViewModifier {
    @Environment(\.isTesting) private var isTesting
    let animation: Animation?
    let value: V

    func body(content: Content) -> some View {
        content
            .animation(isTesting ? nil : animation, value: value)
    }
}

extension View {
    func conditionalAnimation<V: Equatable>(_ animation: Animation?, value: V) -> some View {
        modifier(ConditionalAnimation(animation: animation, value: value))
    }
}
