import SwiftUI
import UIComponents

struct SignOutView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    private var viewModel: SignOutViewModel

    init(viewModel: SignOutViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HeaderView(title: viewModel.title,
                           subheading: viewModel.subTitle)
                BulletView(bulletText: viewModel.bulletStrings)
                    .padding(.bottom, 8)
                Text(viewModel.body)
            }
            .padding(.horizontal, 16)
            Spacer()
            Divider()
                .overlay(Color(UIColor.govUK.strokes.listDivider))
                .ignoresSafeArea()
            let buttonLayout = verticalSizeClass == .compact ?
            AnyLayout(HStackLayout()) :
            AnyLayout(VStackLayout())
            buttonLayout {
                SwiftUIButton(
                    .destructive,
                    viewModel: viewModel.signOutButtonViewModel
                )
                .frame(minHeight: 44, idealHeight: 44)
                SwiftUIButton(
                    .secondary,
                    viewModel: viewModel.cancelButtonViewModel
                )
                .frame(minHeight: 44, idealHeight: 44)
            }
            .ignoresSafeArea()
            .padding(16)
        }
    }
}

extension GOVUKButton.ButtonConfiguration {
    public static var destructive: GOVUKButton.ButtonConfiguration {
        .init(
            titleColorNormal: UIColor.govUK.text.buttonPrimary,
            titleColorHighlighted: nil,
            titleColorFocused: UIColor.govUK.text.buttonPrimaryFocussed,
            titleColorDisabled: UIColor.govUK.text.buttonPrimaryDisabled,
            titleFont: UIFont.govUK.bodySemibold,
            backgroundColorNormal: UIColor.govUK.text.buttonDestructive,
            backgroundColorHighlighted: UIColor.govUK.fills.surfaceButtonPrimaryHighlight,
            backgroundColorFocused: UIColor.govUK.fills.surfaceButtonPrimaryFocussed,
            backgroundColorDisabled: UIColor.govUK.fills.surfaceButtonPrimaryDisabled,
            cornerRadius: 15,
            accessibilityButtonShapesColor: UIColor.govUK.fills.surfaceButtonPrimaryDisabled
        )
    }
}
