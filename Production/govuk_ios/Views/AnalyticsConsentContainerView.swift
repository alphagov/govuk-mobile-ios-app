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
                .font(.title)
                .multilineTextAlignment(.leading)
                .accessibilityAddTraits(.isHeader)
                .accessibilityLabel(Text(viewModel.title))
                .padding(.top, verticalSizeClass == .compact ? 32 : 41)
                .padding(.horizontal, 16)
            ScrollView {
                Text(viewModel.descriptionTop)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                    .multilineTextAlignment(.leading)
                    .accessibilityLabel(Text(viewModel.descriptionTop))
                Text(viewModel.descriptionBullets)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                    .multilineTextAlignment(.leading)
                    .lineSpacing(8)
                    .accessibilityLabel(Text(viewModel.descriptionBullets))
                    .padding(.top, 16)
                Text(viewModel.descriptionBottom)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                    .multilineTextAlignment(.leading)
                    .accessibilityLabel(Text(viewModel.descriptionBottom))
                    .padding(.top, 16)
                Text(viewModel.privacyPolicyLinkTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(UIColor.govUK.text.link))
                    .multilineTextAlignment(.leading)
                    .accessibilityLabel(Text(viewModel.privacyPolicyLinkTitle))
                    .accessibilityHint(Text(viewModel.privacyPolicyLinkHint))
                    .padding(.top, 16)
                    .onTapGesture {
                        viewModel.onPrivacyPolicyClicked()
                    }
            }.padding([.top, .horizontal], 16)
            Spacer()
            AdaptiveStack(spacing: 0) {
                SwiftUIButton(
                    .primary,
                    viewModel: viewModel.allowButtonViewModel
                ).accessibility(sortPriority: 1)
                    .frame(
                        minHeight: 44,
                        idealHeight: 44
                    ).padding(.horizontal, 15)
                SwiftUIButton(
                    .secondary,
                    viewModel: viewModel.dontAllowButtonViewModel
                ).accessibility(sortPriority: 1)
                    .frame(
                        minHeight: 44,
                        idealHeight: 44
                    ).padding(.horizontal, 15)
            }.padding(.top, 16)
                .padding(.bottom, verticalSizeClass == .compact ? 32 : 11)
        }
    }
}
#Preview {
    let viewModel = AnalyticsConsentContainerViewModel(
        analyticsService: nil,
        dismissAction: {})
    return AnalyticsConsentContainerView(viewModel: viewModel)
}
