import SwiftUI

struct ChatMenuView: View {
    private var viewModel: ChatViewModel
    private var menuDimensions: CGSize
    @Binding var showClearChatAlert: Bool
    @Binding var disableClearChat: Bool

    init(viewModel: ChatViewModel,
         menuDimensions: CGSize,
         showClearChatAlert: Binding<Bool>,
         disableClearChat: Binding<Bool>) {
        self.viewModel = viewModel
        self.menuDimensions = menuDimensions
        _showClearChatAlert = showClearChatAlert
        _disableClearChat = disableClearChat
    }

    var body: some View {
        Menu {
            if viewModel.currentConversationExists {
                Button(
                    role: .destructive,
                    action: {
                        viewModel.trackMenuClearChatTap()
                        showClearChatAlert = true
                    },
                    label: {
                        Label(String.chat.localized("clearMenuTitle"),
                              systemImage: "trash")
                    }
                )
                .disabled(disableClearChat)
            }
            Button(
                action: { viewModel.openFeedbackURL() },
                label: {
                    Text(String.chat.localized("feedbackMenuTitle"))
                        .accessibilityLabel(String.chat.localized("feedbackMenuAccessibilityTitle"))
                        .accessibilityHint(String.common.localized("openWebLinkHint"))
                }
            )
            Button(
                action: { viewModel.openPrivacyURL() },
                label: {
                    Text(String.chat.localized("privacyMenuTitle"))
                        .accessibilityLabel(String.chat.localized("optInPrivacyLinkTitle"))
                        .accessibilityHint(String.common.localized("openWebLinkHint"))
                }
            )
            Button(
                action: { viewModel.openAboutURL() },
                label: {
                    Text(String.chat.localized("aboutMenuTitle"))
                        .accessibilityLabel(String.chat.localized("aboutMenuAccessibilityTitle"))
                        .accessibilityHint(String.common.localized("openWebLinkHint"))
                }
            )
        } label: {
            Image(systemName: "ellipsis")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color(UIColor.govUK.text.buttonSecondary))
                .frame(width: menuDimensions.width, height: menuDimensions.height)
                .background(
                    Circle()
                        .fill(Color(UIColor.govUK.fills.surfaceChatAction))
                )
        }
        .accessibilityLabel(String.chat.localized("moreOptionsAccessibilityLabel"))
        .accessibilitySortPriority(0)
    }
}
