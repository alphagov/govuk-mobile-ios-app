import SwiftUI

struct ChatActionView: View {
    @StateObject private var viewModel: ChatViewModel
    @FocusState.Binding var textAreaFocused: Bool
    @AccessibilityFocusState private var errorFocused: Bool
    @AccessibilityFocusState private var warningFocused: Bool
    @State private var placeholderText: String? = String.chat.localized("textEditorPlaceholder")
    @State private var warningErrorHeight: CGFloat = 0
    @Binding var showClearChatAlert: Bool
    private var animationDuration = 0.3
    private var maxTextEditorFrameHeight: CGFloat

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
        warningFocused = shouldShowWarning
        return VStack(spacing: 0) {
            errorView
                .opacity(shouldShowError ? 1 : 0)
                .frame(height: shouldShowError ? nil : 0)
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
            warningView
                .opacity(shouldShowWarning ? 1 : 0)
                .frame(height: shouldShowWarning ? nil : 0)
                .accessibilityFocused($warningFocused)
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .preference(key: HeightPreferenceKey.self, value: geo.size.height)
                    }
                )
                .onPreferenceChange(HeightPreferenceKey.self) { height in
                    warningErrorHeight = height
                }

            chatActionComponentsView(maxFrameHeight: maxTextEditorFrameHeight - warningErrorHeight)
        }
        .onChange(of: viewModel.latestQuestion) { _ in
            if viewModel.latestQuestion.count > viewModel.maxCharacters {
                viewModel.errorText = LocalizedStringKey(
                    "tooManyCharactersTitle.\(viewModel.absoluteRemainingCharacters)"
                )
                viewModel.warningText = nil
            } else if viewModel.latestQuestion.count >= (viewModel.maxCharacters - 50) {
                viewModel.warningText = LocalizedStringKey(
                    "remainingCharactersTitle.\(viewModel.absoluteRemainingCharacters)"
                )
                viewModel.errorText = nil
            } else {
                viewModel.errorText = nil
                viewModel.warningText = nil
            }
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
            HStack(alignment: .center, spacing: 8) {
                textEditorView(maxFrameHeight: maxFrameHeight)
                // UITextView absorbs all taps if focused in HStack, moves ChatMenuView to its
                // own HStack and copies dimensions to an invisible circle
                if shouldShowMenu {
                    Circle().frame(width: 36, height: 36).opacity(0)
                }
            }
            .overlay(alignment: .center) {
                HStack {
                    Spacer()
                    if shouldShowMenu {
                        ChatMenuView(
                            viewModel: viewModel,
                            showClearChatAlert: $showClearChatAlert,
                            disableClearChat: $viewModel.requestInFlight
                        )
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                sendButtonView
                    .padding(.trailing, 6)
            }
        }
        .accessibilityElement(children: .contain)
        .padding([.horizontal, .bottom])
    }

    private var errorView: some View {
        VStack(spacing: 0) {
            if let error = viewModel.errorText {
                Text(error, tableName: "Chat")
                    .fontWeight(.bold)
                    .foregroundStyle(Color(UIColor.govUK.fills.surfaceButtonDestructive))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .ignoresSafeArea(edges: .horizontal)
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, viewModel.errorText != nil ? 8 : 0)
    }

    private var warningView: some View {
        VStack(spacing: 0) {
            if let warning = viewModel.warningText {
                Text(warning, tableName: "Chat")
                    .fontWeight(.bold)
                    .foregroundStyle(Color(UIColor.govUK.text.secondary))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .ignoresSafeArea(edges: .horizontal)
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, viewModel.warningText != nil ? 8 : 0)
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
        .onChange(of: textAreaFocused) { isFocused in
            if (isFocused || !viewModel.latestQuestion.isEmpty) || shouldShowError {
                placeholderText = nil
            } else {
                placeholderText = String.chat.localized("textEditorPlaceholder")
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
        .conditionalAnimation(.easeInOut(duration: animationDuration),
                              value: viewModel.latestQuestion)
        .conditionalAnimation(.easeInOut(duration: animationDuration),
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
            .conditionalAnimation(shouldShowSendButton ? .easeInOut(duration: 0.7) : .none,
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
