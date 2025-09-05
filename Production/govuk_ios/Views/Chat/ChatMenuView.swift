import SwiftUI

struct ChatMenuView: View {
    private var viewModel: ChatViewModel
    @Binding var showClearChatAlert: Bool
    @Binding var disableClearChat: Bool

    init(viewModel: ChatViewModel,
         showClearChatAlert: Binding<Bool>,
         disableClearChat: Binding<Bool>) {
        self.viewModel = viewModel
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
                    Label(String.chat.localized("feedbackMenuTitle"),
                          systemImage: "square.and.pencil.circle.fill")
                        .accessibilityLabel(String.chat.localized("feedbackMenuAccessibilityTitle"))
                        .accessibilityHint(String.common.localized("openWebLinkHint"))
                }
            )
            Button(
                action: { viewModel.openPrivacyURL() },
                label: {
                    Label(String.chat.localized("privacyMenuTitle"),
                          systemImage: "lock.shield.fill")
                        .accessibilityLabel(String.chat.localized("optInPrivacyLinkTitle"))
                        .accessibilityHint(String.common.localized("openWebLinkHint"))
                }
            )
            Button(
                action: { viewModel.openAboutURL() },
                label: {
                    Label(String.chat.localized("aboutMenuTitle"),
                          systemImage: "info.circle")
                        .accessibilityLabel(String.chat.localized("aboutMenuAccessibilityTitle"))
                        .accessibilityHint(String.common.localized("openWebLinkHint"))
                }
            )
        } label: {
            Image(systemName: "ellipsis")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color(UIColor.govUK.text.buttonSecondary))
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(Color(UIColor.govUK.fills.surfaceChatBlue))
                        .overlay(
                            Circle()
                                .stroke(
                                    Color(UIColor.govUK.strokes.chatAction),
                                    lineWidth: 1
                                )
                        )
                )
        }
        .accessibilityLabel(String.chat.localized("moreOptionsAccessibilityLabel"))
        .accessibilitySortPriority(0)
    }
}
