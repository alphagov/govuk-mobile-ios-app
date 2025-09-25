import SwiftUI

struct ChatActionView: View {
    @StateObject private var viewModel: ChatViewModel
    @FocusState.Binding var textAreaFocused: Bool
    @AccessibilityFocusState private var errorFocused: Bool
    @State private var placeholderText: String? = String.chat.localized("textEditorPlaceholder")
    @State private var charactersCountHeight: CGFloat = 0
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
        return VStack(spacing: 0) {
            errorView
                .opacity(shouldShowError ? 1.0 : 0.0)
                .conditionalAnimation(
                    .easeInOut(duration: animationDuration),
                    value: shouldShowError
                )
                .accessibilityFocused($errorFocused)
            chatActionComponentsView(maxFrameHeight: maxTextEditorFrameHeight)
        }
        .onPreferenceChange(CharacterCountHeightKey.self) { height in
            self.charactersCountHeight = height
        }
        .onChange(of: viewModel.latestQuestion) { _ in
            viewModel.errorText = nil
        }
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
        ZStack(alignment: .bottom) {
            HStack(alignment: .center, spacing: 8) {
                if !textAreaFocused {
                    ChatMenuView(
                        viewModel: viewModel,
                        showClearChatAlert: $showClearChatAlert,
                        disableClearChat: $viewModel.requestInFlight
                    )
                }

                textEditorView(maxFrameHeight: maxFrameHeight)
            }
            .accessibilityElement(children: .contain)
            .padding([.horizontal, .bottom])
            sendButtonView
        }
    }
    private var errorView: some View {
        VStack(spacing: 0) {
            if let error = viewModel.errorText {
                Text(error)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(UIColor.govUK.fills.surfaceButtonDestructive))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea(edges: .horizontal)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, viewModel.errorText != nil ? 8 : 0)
    }

    private var shouldShowError: Bool {
        viewModel.errorText != nil
    }


    private func textEditorView(maxFrameHeight: CGFloat) -> some View {
        DynamicTextEditor(
            text: $viewModel.latestQuestion,
            dynamicHeight: $viewModel.textViewHeight,
            placeholderText: $placeholderText
        )
        .focused($textAreaFocused)
        .onChange(of: textAreaFocused) { isFocused in
            if isFocused || !viewModel.latestQuestion.isEmpty {
                placeholderText = nil
            } else {
                placeholderText = String.chat.localized("textEditorPlaceholder")
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 8)
        .padding(.bottom,
                 textAreaFocused ? (max(50, charactersCountHeight)) : 8)
        .frame(
            height: min(textEditorFrameHeight, maxFrameHeight)
        )
        .background(
            Color(UIColor.govUK.fills.surfaceChatBlue)
                .roundedBorder(cornerRadius: textEditorRadius,
                               borderColor: borderColor,
                               borderWidth: 1.0)
        )
        .conditionalAnimation(.easeInOut(duration: animationDuration),
                              value: viewModel.textViewHeight)
        .contentShape(Rectangle())
        .onTapGesture {
            self.textAreaFocused = true
        }
        .accessibilitySortPriority(1)
    }

    private var borderColor: Color {
        if shouldShowError {
            Color(UIColor.govUK.strokes.error)
        } else {
            if textAreaFocused {
                Color(UIColor.govUK.strokes.focusedChatTextBox)
            } else {
                Color(UIColor.govUK.strokes.chatAction)
            }
        }
    }

    private var sendButtonView: some View {
        HStack(alignment: .bottom) {
            if textAreaFocused {
                characterCountView
            }

            Spacer()

            Button(action: askQuestion) {
                Image(systemName: "arrow.up")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                    .foregroundColor(
                        viewModel.shouldDisableSend ?
                        Color(UIColor.govUK.text.buttonPrimaryDisabled) :
                            Color(UIColor.govUK.text.buttonPrimary)
                    )
                    .frame(width: 50, height: 50)
                    .background(
                        Circle().fill(
                            viewModel.shouldDisableSend ?
                            Color(UIColor.govUK.fills.surfaceButtonPrimaryDisabled) :
                                Color(UIColor.govUK.text.buttonSecondary)
                        )
                    )
            }
            .accessibilityLabel(String.chat.localized("sendButtonAccessibilityLabel"))
            .disabled(viewModel.shouldDisableSend)
            .simultaneousGesture(TapGesture().onEnded {
                if viewModel.latestQuestion.isEmpty {
                    self.textAreaFocused = true
                }
            })
            .padding([.bottom, .trailing], 8)
            .opacity(textAreaFocused ? 1 : 0)
            .conditionalAnimation(.easeInOut(duration: animationDuration),
                                  value: textAreaFocused)
        }
        .padding([.horizontal, .bottom])
        .padding(.top, -8)
    }

    @ViewBuilder
    private var characterCountView: some View {
        if viewModel.latestQuestion.count > viewModel.maxCharacters {
            Text(LocalizedStringKey("tooManyCharactersTitle.\(viewModel.absoluteRemainingCharacters)"),
                 tableName: "Chat")
            .font(Font(UIFont.govUK.subheadlineSemibold))
            .foregroundColor(Color(UIColor.govUK.text.buttonDestructive))
            .padding([.leading, .trailing], 16)
            .padding(.bottom, 24)
            .background(GeometryReader { textGeometry in
                Color.clear.preference(
                    key: CharacterCountHeightKey.self,
                    value: textGeometry.size.height
                )
            })
        } else if viewModel.latestQuestion.count >= (viewModel.maxCharacters - 50) {
            Text(LocalizedStringKey("remainingCharactersTitle.\(viewModel.absoluteRemainingCharacters)"),
                 tableName: "Chat")
            .font(Font(UIFont.govUK.subheadline))
            .foregroundColor(Color(UIColor.govUK.text.secondary))
            .padding([.leading, .trailing], 16)
            .padding(.bottom, 24)
            .background(GeometryReader { textGeometry in
                Color.clear.preference(
                    key: CharacterCountHeightKey.self,
                    value: textGeometry.size.height
                )
            })
        }
    }

    private func askQuestion() {
        viewModel.askQuestion { success in
            textAreaFocused = !success
        }
    }

    private var textEditorRadius: CGFloat {
        textAreaFocused ? 25.0 : 40.0
    }

    private var textEditorFrameHeight: CGFloat {
        let font = UIFont.preferredFont(forTextStyle: .body)
        let lineHeight = font.lineHeight
        let unfocusedHeight = viewModel.latestQuestion.isEmpty ?
        max(viewModel.textViewHeight + 10, 50) :
        max(lineHeight + 10, 50)

        return textAreaFocused ?
        viewModel.textViewHeight + max((2 * lineHeight), 75) :
        unfocusedHeight
    }
}

struct CharacterCountHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
