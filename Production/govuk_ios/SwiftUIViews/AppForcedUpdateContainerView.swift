import SwiftUI
import UIComponents

struct AppForcedUpdateContainerView: View {
    @StateObject var viewModel: AppForcedUpdateContainerViewModel

    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(viewModel: AppForcedUpdateContainerViewModel) {
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
            SwiftUIButton(
                .primary,
                viewModel: viewModel.updateButtonViewModel
            )
            .accessibilityLabel(Text(viewModel.updateButtonTitle))
            .frame(minHeight: 44, idealHeight: 44)
            .padding([.top, .horizontal], 16)
            .padding(.bottom, 32)
        }.edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    let viewModel = AppForcedUpdateContainerViewModel()
    return AppForcedUpdateContainerView(viewModel: viewModel)
}
