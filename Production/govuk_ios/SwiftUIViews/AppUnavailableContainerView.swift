import SwiftUI
import UIComponents

struct AppUnavailableContainerView: View {
    @StateObject var viewModel: AppUnavailableContainerViewModel

    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(viewModel: AppUnavailableContainerViewModel) {
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
                SwiftUIButton(
                    .secondary,
                    viewModel: viewModel.goToGovUkButtonViewModel
                )
                .accessibilityLabel(viewModel.goToGovUkAccessibilityButtonTitle)
                .accessibilityHint(viewModel.goToGovUkAccessibilityButtonHint)
                .frame(minHeight: 44, idealHeight: 44)
                .padding([.top, .horizontal], 16)
                .padding(.bottom, 32)
            }.edgesIgnoringSafeArea([.bottom, .horizontal])
        }
    }
}

#Preview {
    let viewModel = AppUnavailableContainerViewModel()
    return AppUnavailableContainerView(viewModel: viewModel)
}
