import SwiftUI

struct ChatActionView: View {
    @StateObject private var viewModel: ChatViewModel
    @FocusState.Binding var textAreaFocused: Bool
    @State private var textViewHeight: CGFloat = 50.0
    @State private var placeholderText: String? = String.chat.localized("textEditorPlaceholder")
    @State private var charactersCountHeight: CGFloat = 0
    private var animationDuration = 0.3

    init(viewModel: ChatViewModel,
         textAreaFocused: FocusState<Bool>.Binding) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _textAreaFocused = textAreaFocused
    }

    var body: some View {
        GeometryReader { geometry in
            let maxTextEditorFrameHeight = geometry.size.height - 32
            VStack {
                Spacer()
                chatActionComponentsView(maxFrameHeight: maxTextEditorFrameHeight)
            }
            .frame(maxHeight: geometry.size.height, alignment: .bottom)
        }
        .onPreferenceChange(CharacterCountHeightKey.self) { height in
            self.charactersCountHeight = height
        }
    }

    private func chatActionComponentsView(maxFrameHeight: CGFloat) -> some View {
        ZStack(alignment: .bottom) {
            chatActionBlurGradient

            HStack(alignment: .center, spacing: 8) {
                if !textAreaFocused {
                    menuView
                }

                textEditorView(maxFrameHeight: maxFrameHeight)
            }
            .conditionalAnimation(.easeInOut(duration: animationDuration),
                                  value: textAreaFocused)
            .accessibilityElement(children: .contain)
            .padding()

            sendButtonView
        }
    }

    private var menuView: some View {
        return Menu {
            Button(role: .destructive, action: clearChat) {
                Label(String.chat.localized("clearMenuTitle"), systemImage: "trash")
            }
            Button(action: showAbout) {
                Label(String.chat.localized("aboutMenuTitle"), systemImage: "info.circle")
            }
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

    private func textEditorView(maxFrameHeight: CGFloat) -> some View {
        ZStack {
            DynamicTextEditor(
                text: $viewModel.latestQuestion,
                dynamicHeight: $textViewHeight,
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
                                   borderColor: textAreaFocused ?
                                   Color(UIColor.govUK.strokes.focusedChatTextBox) :
                                   Color(UIColor.govUK.strokes.chatAction),
                                   borderWidth: 1.0)
            )
            .conditionalAnimation(.easeInOut(duration: animationDuration),
                                  value: textViewHeight)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            self.textAreaFocused = true
        }
        .accessibilitySortPriority(1)
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
        .padding()
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
        viewModel.askQuestion()
        textAreaFocused = false
    }

    private var textEditorRadius: CGFloat {
        textAreaFocused ? 25.0 : 40.0
    }

    private var textEditorFrameHeight: CGFloat {
        let font = UIFont.preferredFont(forTextStyle: .body)
        let lineHeight = font.lineHeight
        let unfocusedHeight = viewModel.latestQuestion.isEmpty ?
        max(textViewHeight + 10, 50) :
        max(lineHeight + 10, 50)

        return textAreaFocused ?
        textViewHeight + max((2 * lineHeight), 75) :
        unfocusedHeight
    }

    private var chatActionBlurGradient: some View {
        VStack(spacing: 0) {
            let blurColor = Color(UIColor.govUK.fills.surfaceChatBackground)
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(
                        color: blurColor.opacity(1),
                        location: 0
                    ),
                    .init(
                        color: blurColor.opacity(0.6),
                        location: 0.8
                    ),
                    .init(
                        color: blurColor.opacity(0),
                        location: 1
                    )
                ]),
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 60)
            .ignoresSafeArea(.all)

            Color(UIColor.govUK.fills.surfaceChatBackground)
                .frame(maxHeight: textEditorFrameHeight - 20, alignment: .bottom)
                .ignoresSafeArea(.all)
        }
        .conditionalAnimation(.easeInOut(duration: animationDuration),
                              value: textViewHeight)
    }

    private func showAbout() {
        print("About tapped")
    }

    private func clearChat() {
        viewModel.newChat()
    }
}

struct CharacterCountHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
