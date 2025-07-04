import SwiftUI
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
            let buttonLayout = verticalSizeClass == .compact ?
            AnyLayout(HStackLayout()) :
            AnyLayout(VStackLayout())
            let buttonsStack = buttonLayout {
                SwiftUIButton(
                    .primary,
                    viewModel: viewModel.enrolButtonViewModel
                )
                .frame(minHeight: 44, idealHeight: 44)
                SwiftUIButton(
                    .secondary,
                    viewModel: viewModel.skipButtonViewModel
                )
                .frame(minHeight: 44, idealHeight: 44)
            }
            VStack(alignment: .center, spacing: 16) {
                Divider()
                    .background(Color(UIColor.govUK.strokes.listDivider))
                    .ignoresSafeArea(edges: [.leading, .trailing])
                    .padding([.top], 0)
            }
            buttonsStack
            .padding([.leading, .trailing], verticalSizeClass == .regular ? 16 : 0)
            .navigationBarBackButtonHidden()
        }.navigationBarHidden(true)
    }
}
