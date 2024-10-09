import SwiftUI
import UIComponents

struct AppForcedUpdateContainerView: View {
    @StateObject var viewModel: AppForcedUpdateContainerViewModel

    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(viewModel: AppForcedUpdateContainerViewModel) {
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
                    .primary,
                    viewModel: viewModel.updateButtonViewModel
                )
                .accessibilityLabel(Text(viewModel.updateButtonTitle))
                .frame(minHeight: 44, idealHeight: 44)
                .padding([.top, .horizontal], 16)
                .padding(.bottom, 32)
            }.edgesIgnoringSafeArea([.bottom, .horizontal])
        }
    }
}

#Preview {
    let viewModel = AppForcedUpdateContainerViewModel()
    return AppForcedUpdateContainerView(viewModel: viewModel)
}
