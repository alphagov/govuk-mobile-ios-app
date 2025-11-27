import SwiftUI
import UIComponents

struct AppForcedUpdateContainerView: View {
    @StateObject var viewModel: AppForcedUpdateContainerViewModel

    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(viewModel: AppForcedUpdateContainerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                HeaderView(title: viewModel.title,
                           subheading: viewModel.subheading)
                .padding(.top, verticalSizeClass == .compact ? 30 : 46)
                .padding(.horizontal, 16)
            }
            Divider()
                .overlay(Color(UIColor.govUK.strokes.fixedContainer))
                .ignoresSafeArea()
            SwiftUIButton(
                .primary,
                viewModel: viewModel.updateButtonViewModel
            )
            .accessibilityLabel(Text(viewModel.updateButtonTitle))
            .frame(minHeight: 44, idealHeight: 44)
            .padding([.top, .horizontal], 16)
            .ignoresSafeArea()
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    let viewModel = AppForcedUpdateContainerViewModel()
    return AppForcedUpdateContainerView(viewModel: viewModel)
}
