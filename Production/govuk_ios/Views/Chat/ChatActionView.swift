import SwiftUI

struct ChatActionView: View {
    @StateObject private var viewModel: ChatViewModel
    @FocusState.Binding var textAreaFocused: Bool
    @AccessibilityFocusState private var errorFocused: Bool
    @State private var placeholderText: String? = String.chat.localized("textEditorPlaceholder")
    @State private var warningErrorHeight: CGFloat = 0
    @Binding var showClearChatAlert: Bool
    private var animationDuration = 0.3
    private var maxTextEditorFrameHeight: CGFloat
    private var menuDimensions: CGSize = CGSize(width: 36, height: 36)

    init(viewModel: ChatViewModel,
         textAreaFocused: FocusState<Bool>.Binding,
         showClearChatAlert: Binding<Bool>,
         maxTextEditorFrameHeight: CGFloat) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _textAreaFocused = textAreaFocused
        _showClearChatAlert = showClearChatAlert
        self.maxTextEditorFrameHeight = maxTextEditorFrameHeight
    }

    var body: some View {
        errorFocused = shouldShowError
        return VStack(spacing: 0) {
            messageView(warningErrorMessage)

            chatActionComponentsView(maxFrameHeight: maxTextEditorFrameHeight - warningErrorHeight)
        }
        .onChange(of: viewModel.latestQuestion) { _ in
            viewModel.updateCharacterCount()
        }
        .conditionalAnimation(
            .easeInOut(duration: animationDuration),
            value: shouldShowError
        )
        .conditionalAnimation(
            .easeInOut(duration: animationDuration),
            value: shouldShowWarning
        )
        .alert(isPresented: $showClearChatAlert) {
            Alert(
                title: Text(String.chat.localized("clearAlertTitle")),
                message: Text(String.chat.localized("clearAlertBodyText")),
                primaryButton: .destructive(
                    Text(String.chat.localized("clearAlertConfirmTitle")),
                    action: {
                        viewModel.newChat()
                        viewModel.trackMenuClearChatConfirmTap()
                    }
                ),
                secondaryButton: .cancel(
                    Text(String.chat.localized("clearAlertDenyTitle")),
                    action: {
                        viewModel.trackMenuClearChatDenyTap()
                    }
                )
            )
        }
    }

    private func chatActionComponentsView(maxFrameHeight: CGFloat) -> some View {
        ZStack {
            let buttonTrailingPadding: CGFloat = 6
            HStack(alignment: .center, spacing: 6) {
                textEditorView(maxFrameHeight: maxFrameHeight)
                // UITextView absorbs all taps if focused in HStack, moves ChatMenuView to its
                // own HStack and copies dimensions to an invisible circle
                if shouldShowMenu {
                    Circle().frame(
                        width: menuDimensions.width,
                        height: menuDimensions.height
                    )
                    .opacity(0)
                    .padding(.trailing, buttonTrailingPadding)
                }
            }
            .overlay(alignment: .center) {
                HStack {
                    Spacer()
                    if shouldShowMenu {
                        ChatMenuView(
                            viewModel: viewModel,
                            menuDimensions: menuDimensions,
                            showClearChatAlert: $showClearChatAlert,
                            disableClearChat: $viewModel.requestInFlight
                        )
                        .padding(.trailing, buttonTrailingPadding)
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                sendButtonView
                    .padding(.trailing, buttonTrailingPadding)
            }
        }
        .accessibilityElement(children: .contain)
        .padding([.horizontal, .bottom])
    }

    private var warningErrorMessage: WarningErrorMessage? {
        if shouldShowError {
            return WarningErrorMessage(
                text: viewModel.errorText,
                type: .error
            )
        } else if shouldShowWarning {
            return WarningErrorMessage(
                text: viewModel.warningText,
                type: .warning
            )
        }
        return nil
    }

    private func messageView(_ warningErrorMessage: WarningErrorMessage?) -> some View {
        VStack(spacing: 0) {
            if let warningErrorMessage = warningErrorMessage,
               let message = warningErrorMessage.text {
                Text(message, tableName: "Chat")
                    .fontWeight(.bold)
                    .foregroundStyle(
                        warningErrorMessage.type == .warning ?
                        Color(UIColor.govUK.text.secondary) :
                            Color(UIColor.govUK.fills.surfaceButtonDestructive)
                    )
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .ignoresSafeArea(edges: .horizontal)
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, warningErrorMessage?.text != nil ? 8 : 0)
        .opacity(shouldShowWarning || shouldShowError ? 1 : 0)
        .frame(height: shouldShowWarning || shouldShowError ? nil : 0)
        .accessibilityFocused($errorFocused)
        .background(
            GeometryReader { geo in
                Color.clear
                    .preference(key: HeightPreferenceKey.self, value: geo.size.height)
            }
        )
        .onPreferenceChange(HeightPreferenceKey.self) { height in
            warningErrorHeight = height
        }
    }

    private var shouldShowError: Bool {
        viewModel.errorText != nil && textAreaFocused
    }

    private var shouldShowWarning: Bool {
        viewModel.errorText == nil &&
        viewModel.warningText != nil &&
        textAreaFocused
    }

    private func textEditorView(maxFrameHeight: CGFloat) -> some View {
        DynamicTextEditor(
            text: $viewModel.latestQuestion,
            dynamicHeight: $viewModel.textViewHeight,
            placeholderText: $placeholderText
        )
        .focused($textAreaFocused)
        .onChange(of: textAreaFocused) { _ in
            if shouldShowError || !viewModel.latestQuestion.isEmpty {
                placeholderText = nil
            } else {
                placeholderText = String.chat.localized("textEditorPlaceholder")
            }
        }
        .onChange(of: viewModel.latestQuestion) { question in
            if question.isEmpty {
                placeholderText = String.chat.localized("textEditorPlaceholder")
            } else {
                placeholderText = nil
            }
        }
        .padding(.leading, 10)
        .padding(.trailing, (viewModel.latestQuestion.isEmpty || !textAreaFocused) ? 10 : 44)
        .padding(.top, 6)
        .padding(.bottom, 4)
        .frame(
            height: min(textEditorFrameHeight, maxFrameHeight)
        )
        .background(
            Color(UIColor.govUK.fills.surfaceChatBlue)
                .clipShape(RoundedRectangle(cornerRadius: 25))
        )
        .conditionalAnimation(.easeInOut(duration: animationDuration),
                              value: viewModel.textViewHeight)
        .conditionalAnimation(.easeInOut(duration: 0.1),
                              value: viewModel.latestQuestion)
        .conditionalAnimation(.easeInOut(duration: 0.2),
                              value: textAreaFocused)
        .contentShape(Rectangle())
        .onTapGesture {
            self.textAreaFocused = true
        }
        .accessibilitySortPriority(1)
    }

    private var sendButtonView: some View {
        HStack(alignment: .bottom) {
            Spacer()

            Button(action: askQuestion) {
                Image(systemName: "arrow.up")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                    .foregroundColor(
                        Color(UIColor.govUK.text.buttonPrimary)
                    )
                    .frame(width: 36, height: 48)
                    .background(
                        Circle().fill(
                            Color(UIColor.govUK.text.buttonSecondary)
                        )
                    )
                    .opacity(viewModel.shouldDisableSend ? 0.4 : 1)
            }
            .accessibilityLabel(String.chat.localized("sendButtonAccessibilityLabel"))
            .disabled(viewModel.shouldDisableSend)
            .simultaneousGesture(TapGesture().onEnded {
                if viewModel.shouldDisableSend {
                    self.textAreaFocused = true
                }
            })
            .scaleEffect(shouldShowSendButton ? 1 : 0.5)
            .opacity(shouldShowSendButton ? 1 : 0)
            .conditionalAnimation(shouldShowSendButton ? .easeInOut(duration: 0.3) : .none,
                                  value: shouldShowSendButton)
        }
        .padding(.leading, 16)
    }

    private func askQuestion() {
        viewModel.askQuestion { success in
            textAreaFocused = !success
        }
    }

    private var textEditorFrameHeight: CGFloat {
        let font = UIFont.preferredFont(forTextStyle: .body)
        let lineHeight = font.lineHeight
        if !textAreaFocused && !viewModel.latestQuestion.isEmpty {
            return max(lineHeight + 26, 48)
        }
        return max(viewModel.textViewHeight + 10, 48)
    }

    private var shouldShowMenu: Bool {
        viewModel.latestQuestion.isEmpty || !textAreaFocused
    }

    private var shouldShowSendButton: Bool {
        textAreaFocused && !viewModel.latestQuestion.isEmpty
    }
}

struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct WarningErrorMessage {
    var text: LocalizedStringKey?
    var type: MessageType

    enum MessageType {
        case warning, error
    }
}
