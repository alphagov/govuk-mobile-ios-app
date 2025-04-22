import SwiftUI
import UIComponents

struct LocalAuthenticationOnboardingView: View {
    @StateObject var viewModel: LocalAuthenticationOnboardingViewModel
    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(viewModel: LocalAuthenticationOnboardingViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 24) {
            ScrollView {
                Image(systemName: viewModel.iconName)
                    .resizable()
                    .frame(width: 64, height: 64)
                    .fontWeight(.light)
                Text(viewModel.title)
                    .multilineTextAlignment(.center)
                    .font(Font.govUK.largeTitleBold)
                    .padding(.bottom, 20)
                Text(viewModel.message)
                    .font(Font.govUK.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                Spacer()
            }
            Divider()
                .foregroundColor(Color(UIColor.govUK.strokes.listDivider))
                .ignoresSafeArea()
            let buttonLayout = verticalSizeClass == .compact ?
            AnyLayout(HStackLayout()) :
            AnyLayout(VStackLayout())
            buttonLayout {
                SwiftUIButton(
                    .primary,
                    viewModel: viewModel.enrolButtonViewModel
                )
                .frame(minHeight: 44, idealHeight: 44)
                .padding(.horizontal, 15)
                SwiftUIButton(
                    .secondary,
                    viewModel: viewModel.skipButtonViewModel
                )
                .frame(minHeight: 44, idealHeight: 44)
                .padding(.horizontal, 15)
            }.padding(.top, 16)
        }.padding(.top, 100)
        .navigationBarBackButtonHidden()
    }
}
