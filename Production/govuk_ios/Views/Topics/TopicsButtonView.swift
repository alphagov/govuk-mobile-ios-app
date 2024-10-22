import SwiftUI
import UIComponents

struct TopicsButtonView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @StateObject var viewModel: TopicOnboardingViewModel

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
                    titleColorNormal: viewModel.isTopicsSelected ?
                    .white : UIColor.govUK.text.secondary,
                    titleColorHighlighted: .white,
                    titleColorFocused: .white,
                    titleFont: UIFont.govUK.bodySemibold,
                    backgroundColorNormal: viewModel.isTopicsSelected ?
                    UIColor.govUK.fills.surfaceButtonPrimary : UIColor(
                        resource: ColorResource(
                            name: "topicOnboardingPrimaryUnselectedBtn",
                            bundle: .main
                        )
                    ),
                    backgroundColorHighlighted: UIColor.govUK.fills.surfaceButtonPrimaryHighlight,
                    backgroundColorFocused: UIColor.govUK.fills.surfaceButtonPrimaryFocussed,
                    cornerRadius: 22,
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
}
