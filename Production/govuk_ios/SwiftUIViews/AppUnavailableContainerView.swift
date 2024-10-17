import SwiftUI
import UIComponents

struct AppUnavailableContainerView: View {
    @StateObject var viewModel: AppUnavailableContainerViewModel

    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(viewModel: AppUnavailableContainerViewModel) {
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
            SwiftUIButton(
                .secondary,
                viewModel: viewModel.goToGovUkButtonViewModel
            )
            .accessibilityLabel(viewModel.goToGovUkAccessibilityButtonTitle)
            .accessibilityHint(viewModel.goToGovUkAccessibilityButtonHint)
            .frame(minHeight: 44, idealHeight: 44)
            .padding([.top, .horizontal], 16)
            .ignoresSafeArea()
        }
    }
}

#Preview {
    let viewModel = AppUnavailableContainerViewModel()
    return AppUnavailableContainerView(viewModel: viewModel)
}
