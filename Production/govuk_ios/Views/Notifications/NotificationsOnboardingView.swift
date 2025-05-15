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
            bouncableScrollView
            buttonStack
        }
        .accessibilityElement(children: .contain)
        .navigationBarHidden(true)
    }

    @ViewBuilder
    private var buttonStack: some View {
        let layout = verticalSizeClass == .compact ?
        AnyLayout(HStackLayout()) :
        AnyLayout(VStackLayout())
        VStack(alignment: .center, spacing: 16) {
            Divider()
                .background(Color(UIColor.govUK.strokes.listDivider))
                .ignoresSafeArea(edges: [.leading, .trailing])
                .padding([.top], 0)
            layout {
                SwiftUIButton(
                    .primary,
                    viewModel: viewModel.primaryButtonViewModel
                )
                .frame(
                    minHeight: 44,
                    idealHeight: 44
                )
                SwiftUIButton(
                    .secondary,
                    viewModel: viewModel.secondaryButtonViewModel
                )
                .frame(
                    minHeight: 44,
                    idealHeight: 44
                )
            }
            .padding([.leading, .trailing], verticalSizeClass == .regular ? 16 : 0)
        }
    }

    private var bouncableScrollView: some View {
        if #available(iOS 16.4, *) {
            return scrollView
                .scrollBounceBehavior(.basedOnSize)
        } else {
            return scrollView
        }
    }

    private var scrollView: some View {
        ScrollView {
            VStack(spacing: 0) {
                if verticalSizeClass == .regular {
                    Spacer(minLength: 32)
                }
                if verticalSizeClass != .compact {
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
    }
}

extension NotificationsOnboardingView: TrackableScreen {
    var trackingName: String { "NotificationsOnboardingScreen" }
    var trackingTitle: String? { "NotificationsOnboardingScreen" }
}
