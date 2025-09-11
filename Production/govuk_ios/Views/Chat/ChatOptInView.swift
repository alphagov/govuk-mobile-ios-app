import SwiftUI
import GOVKit
import UIComponents

struct ChatOptInView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    private var viewModel: ChatOptInViewModel

    init(viewModel: ChatOptInViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            GeometryReader { geometry in
                ScrollView {
                    contentView
                        .frame(width: geometry.size.width)
                        .frame(minHeight: geometry.size.height)
                }.modifier(ScrollBounceBehaviorModifier())
            }
            ButtonStackView(
                primaryButtonViewModel: viewModel.primaryButtonViewModel,
                secondaryButtonViewModel: viewModel.secondaryButtonViewModel
            )
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.trackScreen(screen: self)
        }
    }

    private var contentView: some View {
        VStack {
            if verticalSizeClass != .compact {
                Image(decorative: "chat_onboarding_info")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.bottom, 16)
                    .frame(width: 140, height: 140)
                    .accessibilityHidden(true)
            }

            Text(viewModel.title)
                .fontWeight(.bold)
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .font(Font.govUK.largeTitleBold)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)
                .padding(.bottom, 16)
            Text(String.chat.localized("optInDescription"))
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .font(Font.govUK.body)
                .multilineTextAlignment(.center)
            linksStackView
                .padding(.top, 16)
        }
        .padding(16)
    }

    private var linksStackView: some View {
        VStack(alignment: .center, spacing: 22) {
            linkView(
                text: String.chat.localized("optInPrivacyLinkTitle"),
                link: viewModel.privacyPolicyUrl
            )
            linkView(
                text: String.chat.localized("optInTermsLinkTitle"),
                link: viewModel.termsURL
            )
        }
    }

    private func linkView(text: String, link: URL) -> some View {
        Button(
            action: { viewModel.openURLAction(link) },
            label: {
                Spacer()
                Text(text)
                    .foregroundColor(Color(UIColor.govUK.text.link))
                    .font(Font.govUK.body)
                    .multilineTextAlignment(.center)
                Spacer()
                Image(systemName: "arrow.up.right")
                    .foregroundColor(Color(UIColor.govUK.text.link))
                    .fontWeight(.semibold)
            }
        )
    }
}

extension ChatOptInView: TrackableScreen {
    var trackingName: String {
        "Chat opt-in"
    }

    var trackingTitle: String? {
        viewModel.title
    }
}
