import SwiftUI
import UIComponents

public struct ButtonStackView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    private let primaryButtonViewModel: GOVUKButton.ButtonViewModel
    private let primaryButtonConfiguration: GOVUKButton.ButtonConfiguration
    private let secondaryButtonViewModel: GOVUKButton.ButtonViewModel
    private let secondaryButtonConfiguration: GOVUKButton.ButtonConfiguration

    public init(primaryButtonViewModel: GOVUKButton.ButtonViewModel,
                primaryButtonConfiguration: GOVUKButton.ButtonConfiguration = .primary,
                secondaryButtonViewModel: GOVUKButton.ButtonViewModel,
                secondaryButtonConfiguration: GOVUKButton.ButtonConfiguration = .secondary,) {
        self.primaryButtonViewModel = primaryButtonViewModel
        self.primaryButtonConfiguration = primaryButtonConfiguration
        self.secondaryButtonViewModel = secondaryButtonViewModel
        self.secondaryButtonConfiguration = secondaryButtonConfiguration
    }

    public var body: some View {
        VStack(spacing: 0) {
            Divider()
                .overlay(Color(UIColor.govUK.strokes.listDivider))
                .ignoresSafeArea()
                .padding(.bottom, 16)
            let buttonLayout = verticalSizeClass == .compact ?
            AnyLayout(HStackLayout()) :
            AnyLayout(VStackLayout())
            let buttonsStack = buttonLayout {
                SwiftUIButton(
                    primaryButtonConfiguration,
                    viewModel: primaryButtonViewModel
                )
                .frame(minHeight: 44, idealHeight: 44)
                SwiftUIButton(
                    secondaryButtonConfiguration,
                    viewModel: secondaryButtonViewModel
                )
                .frame(minHeight: 44, idealHeight: 44)
            }
            buttonsStack
                .padding(.horizontal, verticalSizeClass == .regular ? 16 : 0)
        }
    }
}

#Preview {
    let primary = GOVUKButton.ButtonViewModel(
        localisedTitle: "Primary",
        action: { }
    )
    let secondary = GOVUKButton.ButtonViewModel(
        localisedTitle: "Secondary",
        action: { }
    )
    ButtonStackView(primaryButtonViewModel: primary,
                    secondaryButtonViewModel: secondary)
}
