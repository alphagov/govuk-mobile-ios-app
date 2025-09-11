import SwiftUI
import GOVKit

struct ChatView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @StateObject private var viewModel: ChatViewModel
    @Namespace var bottomID
    @FocusState private var textAreaFocused: Bool
    @State var showClearChatAlert: Bool = false
    @State private var appearedIntroCells: [String] = []
    @State private var backgroundOpacity = 0.25
    private let introDuration = 0.5
    private let transitionDuration = 0.3

    init(viewModel: ChatViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(UIColor.govUK.fills.surfaceChatBackground)
                    .edgesIgnoringSafeArea(.all)
                Image(verticalSizeClass == .compact ?
                      "chat_background_landscape" : "chat_background")
                .resizable()
                .opacity(backgroundOpacity)
                .ignoresSafeArea(edges: [.top, .leading, .trailing])

                chatContainerView(geometry.size.height - 32)
                    .conditionalAnimation(.easeInOut(duration: transitionDuration),
                                          value: textAreaFocused)
                    .conditionalAnimation(.easeInOut(duration: transitionDuration),
                                          value: viewModel.textViewHeight)
            }
        }
        .onAppear {
            viewModel.loadHistory()
            viewModel.trackScreen(screen: self)
            withAnimation(
                .easeIn(
                    duration: viewModel.currentConversationExists ? 0.0 : introDuration * 4
                )
            ) {
                backgroundOpacity = 1.0
            }
        }
        .onDisappear {
            backgroundOpacity = 0.25
        }
        .onTapGesture {
            textAreaFocused = false
        }
    }

    private func chatContainerView(_ frameHeight: CGFloat) -> some View {
        let chatActionView = ChatActionView(
            viewModel: viewModel,
            textAreaFocused: $textAreaFocused,
            showClearChatAlert: $showClearChatAlert,
            maxTextEditorFrameHeight: frameHeight
        )

        return VStack(spacing: 0) {
            chatCellsScrollViewReaderView
                .frame(maxHeight: .infinity)
                .layoutPriority(1)
            chatActionView
        }
    }

    private var chatCellsView: some View {
        ForEach(viewModel.cellModels, id: \.id) { cellModel in
            HStack {
                if !cellModel.isAnswer {
                    Spacer(minLength: cellModel.questionWidth)
                }
                chatCellView(cellModel: cellModel)
            }
        }
    }

    private func chatCellView(cellModel: ChatCellViewModel) -> some View {
        ChatCellView(viewModel: cellModel)
            .opacity(
                appearedIntroCells.contains(cellModel.id) ||
                viewModel.currentConversationExists ? 1 : 0
            )
            .animation(.easeIn(duration: introDuration), value: appearedIntroCells)
            .onAppear {
                guard !viewModel.currentConversationExists else {
                    return
                }
                let index = viewModel.cellModels.firstIndex {
                    $0.id == cellModel.id
                } ?? 0
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + Double(index) * 0.7
                ) {
                    withAnimation {
                        appearedIntroCells.insert(cellModel.id, at: index)
                    }
                }
            }
            .padding(.vertical, 4)
    }

    private var chatCellsScrollViewReaderView: some View {
        ScrollViewReader { proxy in
            chatCellsScrollView(proxy: proxy)
        }
        .padding(.horizontal)
    }

    private func chatCellsScrollView(proxy: ScrollViewProxy) -> some View {
        ScrollView {
            Rectangle()
                .fill(Color.clear)
                .frame(height: 16)
            Text(String.chat.localized("messagesAvailableTitle"))
                .font(.subheadline)
                .foregroundStyle(Color(UIColor.govUK.text.secondary))
                .multilineTextAlignment(.center)
            chatCellsView
            Text("")
                .id(bottomID)
        }
        .mask(
            gradientMask
        )
        .scrollIndicators(.hidden)
        .onChange(of: viewModel.scrollToBottom) { shouldScroll in
            if shouldScroll {
                withAnimation {
                    proxy.scrollTo(bottomID, anchor: .bottom)
                }
                viewModel.scrollToBottom = false
            }
        }
        .onChange(of: viewModel.scrollToTop) { shouldScroll in
            if shouldScroll {
                withAnimation {
                    proxy.scrollTo(viewModel.latestQuestionID, anchor: .top)
                }
            }
            viewModel.scrollToTop = false
        }
    }

    var gradientMask: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(
                    color: Color(.black).opacity(0),
                    location: 0
                ),
                .init(
                    color: Color(.black).opacity(1),
                    location: 0.04
                ),
                .init(
                    color: Color(.black).opacity(1),
                    location: 0.94
                ),
                .init(
                    color: Color(.black).opacity(0),
                    location: 1
                )
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

extension ChatView: TrackableScreen {
    var trackingName: String {
        "Chat Screen"
    }

    var trackingTitle: String? {
        "Chat Screen"
    }
}
