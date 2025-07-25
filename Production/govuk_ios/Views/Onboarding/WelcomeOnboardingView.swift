import SwiftUI
import GOVKit
import UIComponents

struct WelcomeOnboardingView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @StateObject var viewModel: WelcomeOnboardingViewModel

    init(viewModel: WelcomeOnboardingViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            GeometryReader { geometry in
                ScrollView {
                    infoView
                        .frame(width: geometry.size.width)
                        .frame(minHeight: geometry.size.height)
                }.modifier(ScrollBounceBehaviorModifier())
            }
            if let versionNumber = viewModel.versionNumber {
                Text(versionNumber)
                    .font(Font.govUK.caption1)
                    .foregroundColor(Color(UIColor.govUK.text.secondary))
                    .padding(.bottom, 16)
            }
            Divider()
                .overlay(Color(UIColor.govUK.strokes.listDivider))
                .ignoresSafeArea()
            SwiftUIButton(
                .primary,
                viewModel: viewModel.buttonViewModel
            )
            .frame(minHeight: 44, idealHeight: 44)
            .padding(16)
            .ignoresSafeArea()
        }
        .navigationBarHidden(true)
    }

    private var infoView: some View {
        VStack {
            if verticalSizeClass != .compact || viewModel.showImageWhenCompact {
                viewModel.image
                    .accessibilityHidden(true)
            }

            Text(viewModel.title)
                .fontWeight(.bold)
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .font(Font.govUK.largeTitleBold)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)
                .padding(.bottom, 16)
            Text(viewModel.subtitle)
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .font(viewModel.subtitleFont)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 16)
    }
}
