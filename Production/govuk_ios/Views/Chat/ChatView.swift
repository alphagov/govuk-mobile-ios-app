import SwiftUI

struct ChatView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @StateObject private var viewModel: ChatViewModel
    @Namespace var bottomID
    @FocusState private var textAreaFocused: Bool
    @State var showClearChatAlert: Bool = false
    @State private var appearedIntroCells: [String] = []
    @State private var backgroundOpacity = 0.25
    private let animationDuration = 0.5

    init(viewModel: ChatViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        GeometryReader { geometry in
            let chatActionView = ChatActionView(
                viewModel: viewModel,
                textAreaFocused: $textAreaFocused,
                showClearChatAlert: $showClearChatAlert,
                maxTextEditorFrameHeight: geometry.size.height - 32
            )

            ZStack {
                Color(UIColor.govUK.fills.surfaceChatBackground)
                    .edgesIgnoringSafeArea(.all)
                Image(verticalSizeClass == .compact ?
                      "chat_background_landscape" : "chat_background")
                .resizable()
                .opacity(backgroundOpacity)
                .ignoresSafeArea(edges: [.top, .leading, .trailing])

                VStack(spacing: 0) {
                    chatCellsScrollViewReaderView
                        .frame(maxHeight: .infinity)
                        .layoutPriority(1)
                    chatActionView
                }
            }
        }
        .onAppear {
            viewModel.loadHistory()
            withAnimation(
                .easeIn(
                    duration: viewModel.currentConversationExists ? 0.0 : animationDuration * 3
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
            .animation(.easeIn(duration: animationDuration), value: appearedIntroCells)
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
                .frame(height: 8)
            Text(String.chat.localized("messagesAvailableTitle"))
                .font(.subheadline)
                .foregroundStyle(Color(UIColor.govUK.text.chatBackground))
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
        .onChange(of: viewModel.answeredQuestionID) { id in
            withAnimation {
                proxy.scrollTo(id, anchor: .top)
            }
            viewModel.answeredQuestionID = ""
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
                    location: 0.03
                ),
                .init(
                    color: Color(.black).opacity(1),
                    location: 0.97
                ),
                .init(
                    color: Color(.black).opacity(0),
                    location: 1
                )
            ]),
            startPoint: .bottom,
            endPoint: .top
        )
    }
}
