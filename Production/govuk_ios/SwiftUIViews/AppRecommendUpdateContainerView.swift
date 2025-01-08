import SwiftUI
import UIComponents

struct AppRecommendUpdateContainerView: View {
    @StateObject var viewModel: AppRecommendUpdateContainerViewModel

    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(viewModel: AppRecommendUpdateContainerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            HeaderView(title: viewModel.title,
                       subheading: viewModel.subheading)
            .padding(.top, verticalSizeClass == .compact ? 30 : 46)
            .padding(.horizontal, 16)
            Spacer()
            Divider()
                .foregroundColor(Color(UIColor.govUK.strokes.listDivider))
                .ignoresSafeArea()
            let buttonLayout = verticalSizeClass == .compact ?
            AnyLayout(HStackLayout()) :
            AnyLayout(VStackLayout())
            buttonLayout {
                SwiftUIButton(
                    .primary,
                    viewModel: viewModel.updateButtonViewModel
                )
                .frame(minHeight: 44, idealHeight: 44)
                .padding(.horizontal, 16)
                .accessibilityLabel(Text(viewModel.updateButtonTitle))
                SwiftUIButton(
                    .secondary,
                    viewModel: viewModel.skipButtonViewModel
                )
                .frame(minHeight: 44, idealHeight: 44)
                .padding(.horizontal, 16)
                .accessibilityLabel(Text(viewModel.skipButtonTitle))
            }
            .padding(.top, 16)
            .ignoresSafeArea()
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    let viewModel = AppRecommendUpdateContainerViewModel(dismissAction: {})
    return AppRecommendUpdateContainerView(viewModel: viewModel)
}
