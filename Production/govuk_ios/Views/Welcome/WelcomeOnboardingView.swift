import Foundation
import SwiftUI
import UIComponents
import GOVKit

struct WelcomeOnboardingView: View {
    @StateObject private var viewModel: WelcomeOnboardingViewModel
    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(viewModel: WelcomeOnboardingViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            bouncableScrollView
            buttonStack
        }
        .accessibilityElement(children: .contain)
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
                    Spacer(minLength: 64)
                }
                if verticalSizeClass != .compact {
                    Image(decorative: "onboarding_welcome")
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
                    .font(Font(UIFont.govUK.title1))
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                    .multilineTextAlignment(.center)
                    .accessibilityLabel(Text(viewModel.body))
                    .padding([.leading, .trailing], 16)
                    .accessibilitySortPriority(0)
                .accessibilityElement(children: .combine)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 24)
                Spacer()
            }
        }
        .padding(.top, verticalSizeClass == .compact ? 30 : 46)
        .padding(.horizontal, 16)
    }
}

extension WelcomeOnboardingView: TrackableScreen {
    var trackingName: String { "WelcomeOnboardingScreen" }
    var trackingTitle: String? { "WelcomeOnboardingScreen" }
}
