import Foundation
import SwiftUI
import UIComponents
import GOVKit

class NotificationsOnboardingViewModel: ObservableObject {
    let urlOpener: URLOpener
    let analyticsService: AnalyticsServiceInterface
    let completeAction: () -> Void
    let dismissAction: () -> Void

    init(urlOpener: URLOpener,
         analyticsService: AnalyticsServiceInterface,
         completeAction: @escaping () -> Void,
         dismissAction: @escaping () -> Void) {
        self.urlOpener = urlOpener
        self.analyticsService = analyticsService
        self.completeAction = completeAction
        self.dismissAction = dismissAction
    }

    let title: String = String.notifications.localized(
        "onboardingTitle"
    )
    let body: String = String.notifications.localized("onboardingBody")
    let privacyPolicyLinkTitle: String = String.notifications.localized(
        "onboardingPrivacyButtonTitle"
    )

    var primaryButtonViewModel: GOVUKButton.ButtonViewModel {
        let title = String.notifications.localized("onboardingAcceptButtonTitle")
        return .init(
            localisedTitle: title,
            action: { [weak self] in
                self?.trackButtonActionEvent(title: title)
                self?.completeAction()
            }
        )
    }

    var secondaryButtonViewModel: GOVUKButton.ButtonViewModel {
        let title = String.notifications.localized("onboardingSkipButtonTitle")
        return .init(
            localisedTitle: title,
            action: { [weak self] in
                self?.trackButtonActionEvent(title: title)
                self?.dismissAction()
            }
        )
    }

    func openPrivacyPolicy() {
        urlOpener.openPrivacyPolicy()
    }

    private func trackButtonActionEvent(title: String) {
        let event = AppEvent.buttonNavigation(text: title, external: false)
        analyticsService.track(event: event)
    }
}

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
            VStack {
                if verticalSizeClass == .regular {
                    Spacer(minLength: 32)
                }
                if verticalSizeClass != .compact {
                    Image(decorative: "onboarding_notifications")
                }
                Text(viewModel.title)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .accessibilityLabel(Text(viewModel.title))
                    .padding(.top, verticalSizeClass == .compact ? 32 : 0)
                    .padding([.trailing, .leading], 16)
                    .accessibilityAddTraits(.isHeader)
                    .accessibilitySortPriority(1)
                Text(viewModel.body)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                    .multilineTextAlignment(.center)
                    .accessibilityLabel(Text(viewModel.body))
                    .padding([.top, .leading, .trailing], 16)
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
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 16)
                .onTapGesture {
                    viewModel.openPrivacyPolicy()
                }
                Spacer()
            }
        }
        .padding(.top, verticalSizeClass == .compact ? 30 : 46)
        .padding(.horizontal, 16)
        .accessibilityValue(" ")
    }
}

extension NotificationsOnboardingView: TrackableScreen {
    var trackingName: String { "NotificationsOnboardingScreen" }
    var trackingTitle: String? { "NotificationsOnboardingScreen" }
}
