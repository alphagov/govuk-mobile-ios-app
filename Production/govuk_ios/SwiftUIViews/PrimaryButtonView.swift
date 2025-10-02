import SwiftUI
import UIComponents

struct PrimaryButtonView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    private let viewModel: GOVUKButton.ButtonViewModel

    init(viewModel: GOVUKButton.ButtonViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Divider()
                .overlay(Color(UIColor.govUK.strokes.fixedContainer))
                .ignoresSafeArea()
                .padding([.top], 0)
                SwiftUIButton(
                    .primary,
                    viewModel: viewModel
                )
                .frame(
                    minHeight: 44,
                    idealHeight: 44
                )
                .padding([.horizontal], verticalSizeClass == .regular ? 16 : 0)
        }
        .accessibilityElement(children: .contain)
    }
}
