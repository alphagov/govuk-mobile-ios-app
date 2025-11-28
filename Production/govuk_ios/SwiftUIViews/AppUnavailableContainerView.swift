import SwiftUI
import UIComponents

struct AppUnavailableContainerView: View {
    @StateObject var viewModel: AppUnavailableContainerViewModel

    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(viewModel: AppUnavailableContainerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                HeaderView(title: viewModel.title,
                           subheading: viewModel.subheading)
                .padding(.top, verticalSizeClass == .compact ? 30 : 46)
                .padding(.horizontal, 16)
                ProgressView()
                    .controlSize(.large)
                    .opacity(viewModel.showProgressView ? 1 : 0)
                    .padding(.top, 32)
            }
            .padding(.top, 1)
            Divider()
                .overlay(Color(UIColor.govUK.strokes.fixedContainer))
                .ignoresSafeArea()
            SwiftUIButton(
                viewModel.error == AppConfigError.networkUnavailable ? .primary : .secondary,
                viewModel: viewModel.buttonViewModel
            )
            .accessibilityLabel(viewModel.buttonAccessibilityTitle)
            .accessibilityHint(viewModel.buttonAccessibilityHint)
            .frame(minHeight: 44, idealHeight: 44)
            .padding([.top, .horizontal], 16)
            .ignoresSafeArea()
            .disabled(viewModel.showProgressView)
        }
        .navigationBarHidden(true)
    }
}
