import SwiftUI
import UIComponents

struct AnalyticsConsentContainerView: View {
    @StateObject var viewModel: AnalyticsConsentContainerViewModel
    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(viewModel: AnalyticsConsentContainerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            ScrollView {
                HeaderView(title: viewModel.title,
                           subheading: viewModel.descriptionTop)
                Text(viewModel.descriptionBullets)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                    .font(Font.govUK.body)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(8)
                    .accessibilityLabel(Text(viewModel.descriptionBullets))
                    .padding(.top, 16)
                Text(viewModel.descriptionBottom)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                    .font(Font.govUK.body)
                    .multilineTextAlignment(.leading)
                    .accessibilityLabel(Text(viewModel.descriptionBottom))
                    .padding(.top, 16)
                Text(viewModel.privacyPolicyLinkTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(UIColor.govUK.text.link))
                    .font(Font.govUK.body)
                    .multilineTextAlignment(.leading)
                    .accessibilityLabel(Text(viewModel.privacyPolicyLinkAccessibilityTitle))
                    .accessibilityHint(Text(viewModel.privacyPolicyLinkHint))
                    .accessibilityAddTraits(.isLink)
                    .padding(.top, 16)
                    .onTapGesture {
                        viewModel.openPrivacyPolicy()
                    }
            }.padding(.top, verticalSizeClass == .compact ? 30 : 46)
            .padding(.horizontal, 16)
            .accessibilityValue(" ")
            Spacer()
            Divider()
                .overlay(Color(UIColor.govUK.strokes.listDivider))
                .ignoresSafeArea()
            let buttonLayout = verticalSizeClass == .compact ?
            AnyLayout(HStackLayout()) :
            AnyLayout(VStackLayout())
            buttonLayout {
                SwiftUIButton(
                    .primary,
                    viewModel: viewModel.allowButtonViewModel
                )
                .frame(minHeight: 44, idealHeight: 44)
                .padding(.horizontal, 15)
                SwiftUIButton(
                    .secondary,
                    viewModel: viewModel.dontAllowButtonViewModel
                )
                .frame(minHeight: 44, idealHeight: 44)
                .padding(.horizontal, 15)
            }.padding(.top, 16)
            .ignoresSafeArea()
            .navigationBarHidden(true)
        }
    }
}
