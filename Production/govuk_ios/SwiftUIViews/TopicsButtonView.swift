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
            .overlay(Color(UIColor.govUK.strokes.listDivider))
            .ignoresSafeArea(edges: [.leading, .trailing])
            .padding([.top], 0)
        let buttonLayout = verticalSizeClass == .compact ?
        AnyLayout(HStackLayout()) :
        AnyLayout(VStackLayout())
        buttonLayout {
            SwiftUIButton(
                .primary,
                viewModel: viewModel.primaryButtonViewModel
            )
            .disabled(!viewModel.isTopicSelected)
            .accessibility(sortPriority: 1)
            .frame(
                minHeight: 44,
                idealHeight: 44
            )
            SwiftUIButton(
                .secondary,
                viewModel: viewModel.secondaryButtonViewModel
            )
            .accessibility(sortPriority: 0)
            .frame(
                minHeight: 44,
                idealHeight: 44
            )
        }.padding(.top)
            .padding(
                [.leading, .trailing],
                verticalSizeClass == .regular ? 16 : 0
            )
    }
}
