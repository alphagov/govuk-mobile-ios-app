import SwiftUI
import UIComponents

public struct ButtonStackView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    private let primaryButtonViewModel: GOVUKButton.ButtonViewModel
    private let primaryButtonConfiguration: GOVUKButton.ButtonConfiguration
    private let secondaryButtonViewModel: GOVUKButton.ButtonViewModel
    private let secondaryButtonConfiguration: GOVUKButton.ButtonConfiguration
    var primaryDisabled: Bool
    var secondaryDisabled: Bool

    public init(primaryButtonViewModel: GOVUKButton.ButtonViewModel,
                primaryButtonConfiguration: GOVUKButton.ButtonConfiguration = .primary,
                primaryDisabled: Bool = false,
                secondaryButtonViewModel: GOVUKButton.ButtonViewModel,
                secondaryButtonConfiguration: GOVUKButton.ButtonConfiguration = .secondary,
                secondaryDisabled: Bool = false) {
        self.primaryButtonViewModel = primaryButtonViewModel
        self.primaryButtonConfiguration = primaryButtonConfiguration
        self.secondaryButtonViewModel = secondaryButtonViewModel
        self.secondaryButtonConfiguration = secondaryButtonConfiguration
        self.primaryDisabled = primaryDisabled
        self.secondaryDisabled = secondaryDisabled
    }

    public var body: some View {
        VStack(spacing: 0) {
            Divider()
                .overlay(Color(UIColor.govUK.strokes.fixedContainer))
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
                .disabled(primaryDisabled)
                SwiftUIButton(
                    secondaryButtonConfiguration,
                    viewModel: secondaryButtonViewModel
                )
                .frame(minHeight: 44, idealHeight: 44)
                .disabled(secondaryDisabled)
            }
            buttonsStack
                .padding(.horizontal, verticalSizeClass == .regular ? 16 : 0)
        }
        .background(Color(UIColor.govUK.fills.surfaceFixedContainer))
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
