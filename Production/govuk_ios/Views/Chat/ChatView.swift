import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel
    @Namespace var bottomID
    @FocusState private var textAreaFocused: Bool

    init(viewModel: ChatViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        let chatActionView = ChatActionView(
            viewModel: viewModel,
            textAreaFocused: $textAreaFocused
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
                ChatCellView(viewModel: cellModel)
                    .padding(.vertical, 4)
            }
        }
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
                .frame(height: 4)
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
