import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel
    @Namespace var bottomID
    @FocusState private var textAreaFocused: Bool
    @State var showClearChatAlert: Bool = false
    @State private var appearedIntroCells: [String] = []

    init(viewModel: ChatViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        let chatActionView = ChatActionView(
            viewModel: viewModel,
            textAreaFocused: $textAreaFocused,
            showClearChatAlert: $showClearChatAlert
        )

        ZStack {
            Color(UIColor.govUK.fills.surfaceChatBackground)
                .edgesIgnoringSafeArea(.all)

            chatCellsScrollViewReaderView
                .frame(maxHeight: .infinity)

            topBlurGradientView

            chatActionView
        }
        .onAppear {
            viewModel.loadHistory()
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
            .animation(.easeIn(duration: 0.5), value: appearedIntroCells)
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
            Rectangle()
                .fill(Color.clear)
                .frame(height: 66)
            Text("")
                .id(bottomID)
        }
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

    private var topBlurGradientView: some View {
        VStack {
            let blurColor = Color(UIColor.govUK.fills.surfaceBackground)
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(
                        color: blurColor.opacity(1),
                        location: 0
                    ),
                    .init(
                        color: blurColor.opacity(0.8),
                        location: 0.7
                    ),
                    .init(
                        color: blurColor.opacity(0),
                        location: 1
                    )
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(.all)
            .frame(height: 20)

            Spacer()
        }
    }
}
