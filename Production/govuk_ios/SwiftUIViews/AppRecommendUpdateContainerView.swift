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
            Text(viewModel.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .font(Font.govUK.title1)
                .multilineTextAlignment(.leading)
                .accessibilityAddTraits(.isHeader)
                .accessibilityLabel(Text(viewModel.title))
                .padding(.top, verticalSizeClass == .compact ? 30 : 46)
                .padding(.horizontal, 16)
            Text(viewModel.subheading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .font(Font.govUK.subheadline)
                .multilineTextAlignment(.leading)
                .accessibilityLabel(Text(viewModel.subheading))
                .padding(.top, verticalSizeClass == .compact ? 16 : 24)
                .padding(.horizontal, 16)
            Spacer()
            Divider()
                .foregroundColor(Color(UIColor.govUK.strokes.listDivider))
            AdaptiveStack {
                SwiftUIButton(
                    .primary,
                    viewModel: viewModel.updateButtonViewModel
                )
                .frame(minHeight: 44, idealHeight: 44)
                .padding(.horizontal, 15)
                .accessibilityLabel(Text(viewModel.updateButtonTitle))
                SwiftUIButton(
                    .secondary,
                    viewModel: viewModel.skipButtonViewModel
                )
                .frame(minHeight: 44, idealHeight: 44)
                .padding(.horizontal, 15)
            }
            .padding(.top, 16)
            .padding(.bottom, 32)
        }.edgesIgnoringSafeArea([.bottom, .horizontal])
    }
}

#Preview {
    let viewModel = AppRecommendUpdateContainerViewModel(dismissAction: {})
    return AppRecommendUpdateContainerView(viewModel: viewModel)
}
