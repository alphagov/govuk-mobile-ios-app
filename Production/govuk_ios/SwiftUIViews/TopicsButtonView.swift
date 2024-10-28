import SwiftUI
import UIComponents

struct TopicsButtonView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @StateObject var viewModel: TopicOnboardingViewModel
    @Environment(\.colorScheme) var colorScheme

    init(viewModel: TopicOnboardingViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        Divider()
            .background(Color(UIColor.govUK.strokes.listDivider))
            .ignoresSafeArea(edges: [.leading, .trailing])
            .padding([.top], 0)
        AdaptiveStack {
            SwiftUIButton(
                .init(
                    titleColorNormal: configureTitleColour(),
                    titleColorHighlighted: UIColor.govUK.text.buttonPrimary,
                    titleColorFocused: .white,
                    titleFont: UIFont.govUK.bodySemibold,
                    backgroundColorNormal: configurePrimaryButtonColour(),
                    backgroundColorHighlighted: configurePrimaryButtonColour(),
                    backgroundColorFocused: UIColor.govUK.fills.surfaceButtonPrimaryFocussed,
                    backgroundColorDisabled: .gray, cornerRadius: 22,
                    accessibilityButtonShapesColor: .blue
                ),
                viewModel: viewModel.primaryButtonViewModel
            )
            .accessibilityHint("hint placeholder")
            .accessibility(sortPriority: 1)
            .frame(
                minHeight: 44,
                idealHeight: 44
            )
            SwiftUIButton(
                .secondary,
                viewModel: viewModel.secondaryButtonViewModel
            )
            .accessibilityHint("hint placeholder")
            .accessibility(sortPriority: 0)
            .frame(
                minHeight: 44,
                idealHeight: 44
            )
        }.padding(.top)
            .padding([.leading, .trailing], verticalSizeClass == .regular ? 16 : 0)
    }

    private func configurePrimaryButtonColour() -> UIColor {
        if colorScheme == .dark {
            return UIColor.govUK.fills.surfaceButtonPrimary
        } else {
            switch viewModel.isTopicsSelected {
            case true:
                return UIColor.govUK.fills.surfaceButtonPrimary
            case false:
                return UIColor(
                    resource: ColorResource(
                        name: "topicOnboardingPrimaryUnselectedBtn",
                        bundle: .main
                    )
                )
            }
        }
    }

    private func configureTitleColour() -> UIColor {
        if colorScheme == .dark {
            return UIColor.govUK.text.buttonPrimary
        } else {
            switch viewModel.isTopicsSelected {
            case true:
                return UIColor.govUK.text.buttonPrimary
            case false:
                return UIColor.govUK.text.secondary
            }
        }
    }
}
