import SwiftUI
import GOVKit
import UIComponents

struct LocalAuthenticationOnboardingView: View {
    @StateObject var viewModel: LocalAuthenticationOnboardingViewModel
    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(viewModel: LocalAuthenticationOnboardingViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            if verticalSizeClass == .regular {
                Spacer(minLength: 32)
            }
            let imageTopPadding = verticalSizeClass == .compact ? CGFloat(16) : CGFloat(64)
            ScrollView {
                Image(systemName: viewModel.iconName)
                    .resizable()
                    .frame(width: 64, height: 64)
                    .fontWeight(.thin)
                    .padding(.top, imageTopPadding)
                    .padding(.horizontal, 16)
                    .accessibilityHidden(true)
                Text(viewModel.title)
                    .multilineTextAlignment(.center)
                    .font(Font.govUK.largeTitleBold)
                    .padding(.bottom, 16)
                    .accessibilityAddTraits(.isHeader)
                    .accessibilitySortPriority(1)
                VStack(alignment: .center, spacing: 24) {
                    ForEach(viewModel.message.split(separator: "\n\n"), id: \.self) { paragraph in
                        Text(paragraph)
                            .font(Font.govUK.body)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }
                    Spacer()
                }
            }
            .accessibilityElement(children: .contain)
            ButtonStackView(
                primaryButtonViewModel: viewModel.enrolButtonViewModel,
                secondaryButtonViewModel: viewModel.skipButtonViewModel
            )
        }
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
        .background(Color(uiColor: UIColor.govUK.fills.surfaceFullscreen))
    }
}
