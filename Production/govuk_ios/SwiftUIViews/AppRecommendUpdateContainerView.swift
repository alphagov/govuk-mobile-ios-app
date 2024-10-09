import SwiftUI
import UIComponents

struct AppRecommendUpdateContainerView: View {
    @StateObject var viewModel: AppRecommendUpdateContainerViewModel

    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(viewModel: AppRecommendUpdateContainerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        GeometryReader { geo in
            VStack {
                HeaderView(title: viewModel.title,
                           subheading: viewModel.subheading)
                .padding(.top, verticalSizeClass == .compact ? 30 : 46)
                .padding(.horizontal, 16 + geo.safeAreaInsets.leading)
                Spacer()
                Divider()
                    .foregroundColor(Color(UIColor.govUK.strokes.listDivider))
                AdaptiveStack {
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
                .padding(.bottom, 32)
            }.edgesIgnoringSafeArea([.bottom, .horizontal])
        }
    }
}

#Preview {
    let viewModel = AppRecommendUpdateContainerViewModel(dismissAction: {})
    return AppRecommendUpdateContainerView(viewModel: viewModel)
}
