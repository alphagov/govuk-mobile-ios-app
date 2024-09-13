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
            Text(viewModel.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .font(Font.govUK.title1)
                .multilineTextAlignment(.leading)
                .accessibilityAddTraits(.isHeader)
                .accessibilityLabel(Text(viewModel.title))
                .padding(.top, verticalSizeClass == .compact ? 32 : 46)
                .padding(.horizontal, 16)
            ScrollView {
                Text(viewModel.descriptionTop)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                    .font(Font.govUK.subheadline)
                    .multilineTextAlignment(.leading)
                    .accessibilityLabel(Text(viewModel.descriptionTop))
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
                    .font(Font.govUK.subheadline)
                    .multilineTextAlignment(.leading)
                    .accessibilityLabel(Text(viewModel.descriptionBottom))
                    .padding(.top, 16)
                Text(viewModel.privacyPolicyLinkTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(UIColor.govUK.text.link))
                    .font(Font.govUK.subheadline)
                    .multilineTextAlignment(.leading)
                    .accessibilityLabel(Text(viewModel.privacyPolicyLinkTitle))
                    .accessibilityHint(Text(viewModel.privacyPolicyLinkHint))
                    .padding(.top, 16)
                    .onTapGesture {
                        viewModel.openPrivacyPolicy()
                    }
            }.padding(.top, verticalSizeClass == .compact ? 16 : 24)
            .padding(.horizontal, 16)
            Spacer()
            AdaptiveStack {
                SwiftUIButton(
                    .primary,
                    viewModel: viewModel.allowButtonViewModel
                ).accessibility(sortPriority: 1)
                .frame(minHeight: 44, idealHeight: 44)
                .padding(.horizontal, 15)
                SwiftUIButton(
                    .secondary,
                    viewModel: viewModel.dontAllowButtonViewModel
                ).accessibility(sortPriority: 1)
                .frame(minHeight: 44, idealHeight: 44)
                .padding(.horizontal, 15)
            }.padding(.top, 16)
            .padding(.bottom, 32)
        }
    }
}
#Preview {
    let viewModel = AnalyticsConsentContainerViewModel(
        analyticsService: nil,
        dismissAction: {})
    return AnalyticsConsentContainerView(viewModel: viewModel)
}
