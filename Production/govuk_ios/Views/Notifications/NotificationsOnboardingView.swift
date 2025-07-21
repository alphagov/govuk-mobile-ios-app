import Foundation
import SwiftUI
import UIComponents
import GOVKit

struct NotificationsOnboardingView: View {
    @StateObject private var viewModel: NotificationsOnboardingViewModel
    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(viewModel: NotificationsOnboardingViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            scrollView
            ButtonStackView(
                primaryButtonViewModel: viewModel.primaryButtonViewModel,
                secondaryButtonViewModel: viewModel.secondaryButtonViewModel
            )
        }
        .background(Color(uiColor: UIColor.govUK.fills.surfaceBackground))
        .accessibilityElement(children: .contain)
    }

    private var scrollView: some View {
        ScrollView {
            VStack(spacing: 0) {
                if verticalSizeClass == .regular {
                    Spacer(minLength: 32)
                }
                if viewModel.showImage && verticalSizeClass != .compact {
                    Image(decorative: "onboarding_notifications")
                }
                Text(viewModel.title)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                    .font(Font(UIFont.govUK.largeTitleBold))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .accessibilityLabel(Text(viewModel.title))
                    .padding(.top, verticalSizeClass == .compact ? 32 : 24)
                    .padding([.trailing, .leading], 16)
                    .accessibilityAddTraits(.isHeader)
                    .accessibilitySortPriority(1)
                Text(viewModel.body)
                    .font(Font(UIFont.govUK.body))
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                    .multilineTextAlignment(.center)
                    .accessibilityLabel(Text(viewModel.body))
                    .padding([.leading, .trailing], 16)
                    .padding(.top, 24)
                    .accessibilitySortPriority(0)
                HStack(alignment: .center) {
                    Text(viewModel.privacyPolicyLinkTitle)
                        .frame(alignment: .center)
                        .foregroundColor(Color(UIColor.govUK.text.link))
                        .font(Font.govUK.body)
                        .multilineTextAlignment(.center)
                        .accessibilityHint(Text(String.common.localized("openWebLinkHint")))
                        .accessibilityAddTraits(.isLink)
                    Image(systemName: "arrow.up.right")
                        .foregroundColor(Color(UIColor.govUK.text.link))
                }
                .accessibilityElement(children: .combine)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 24)
                .onTapGesture {
                    viewModel.openPrivacyPolicy()
                }
                Spacer()
            }
        }
        .padding(.top, verticalSizeClass == .compact ? 30 : 46)
        .padding(.horizontal, 16)
        .modifier(ScrollBounceBehaviorModifier())
    }
}

extension NotificationsOnboardingView: TrackableScreen {
    var trackingName: String { "NotificationsOnboardingScreen" }
    var trackingTitle: String? { "NotificationsOnboardingScreen" }
}
