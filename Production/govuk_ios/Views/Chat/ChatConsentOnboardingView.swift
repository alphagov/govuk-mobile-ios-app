import SwiftUI
import GOVKit
import UIComponents

struct ChatConsentOnboardingView: View {
    private var viewModel: ChatConsentOnboardingViewModel

    init(viewModel: ChatConsentOnboardingViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    ScrollView {
                        consentView
                            .frame(width: geometry.size.width)
                            .frame(minHeight: geometry.size.height)
                    }.modifier(ScrollBounceBehaviorModifier())
                }
                Divider()
                    .overlay(Color(UIColor.govUK.strokes.listDivider))
                    .ignoresSafeArea()
                SwiftUIButton(
                    .primary,
                    viewModel: viewModel.buttonViewModel
                )
                .frame(minHeight: 44, idealHeight: 44)
                .padding(16)
                .ignoresSafeArea()
            }
        }
    }

    private var consentView: some View {
        VStack {
            Image(decorative: "chat_onboarding_consent")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.bottom, 16)
                .frame(width: 120, height: 120)
                .accessibilityHidden(true)

            Text(LocalizedStringKey("onboardingConsentTitle"),
                 tableName: "Chat")
                .fontWeight(.bold)
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .font(Font.govUK.largeTitleBold)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)
                .padding(.bottom, 16)

            listView
        }
        .padding(.horizontal, 16)
    }

    private var listView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center, spacing: 16) {
                Image(systemName: "info.circle")
                    .foregroundColor(Color(UIColor.govUK.text.trailingIcon))
                Text(LocalizedStringKey("onboardingConsentFirstListItemText"),
                     tableName: "Chat")
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .font(Font.govUK.body)
            }
            .padding([.top, .horizontal], 16)

            Divider().background(Color.white)

            HStack(alignment: .center, spacing: 16) {
                Image(systemName: "doc.text")
                    .foregroundColor(Color(UIColor.govUK.text.trailingIcon))
                Text(LocalizedStringKey("onboardingConsentSecondListItemText"),
                     tableName: "Chat")
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .font(Font.govUK.body)
            }
            .padding([.bottom, .horizontal], 16)
        }
        //  .background(Color(UIColor.govUK.fills.surfaceChatOnboardingListBackground))
        .cornerRadius(10)
    }
}

extension ChatConsentOnboardingView: TrackableScreen {
    var trackingName: String {
        "Second chat onboarding"
    }

    var trackingTitle: String? {
        "Double-check the answers"
    }
}
