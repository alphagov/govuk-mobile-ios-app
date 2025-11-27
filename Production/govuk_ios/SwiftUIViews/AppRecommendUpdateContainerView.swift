import SwiftUI
import GOVKit
import UIComponents

struct AppRecommendUpdateContainerView: View {
    @StateObject var viewModel: AppRecommendUpdateContainerViewModel

    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(viewModel: AppRecommendUpdateContainerViewModel) {
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
            ButtonStackView(
                primaryButtonViewModel: viewModel.updateButtonViewModel,
                secondaryButtonViewModel: viewModel.skipButtonViewModel
            )
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    let viewModel = AppRecommendUpdateContainerViewModel(
        dismissAction: {
            // Do nothing
        }
    )
    return AppRecommendUpdateContainerView(viewModel: viewModel)
}
