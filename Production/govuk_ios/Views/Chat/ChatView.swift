import SwiftUI
import GOVKit
import UIComponents

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel
    @Namespace var bottomID

    init(viewModel: ChatViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        ZStack {
            VStack {
                chatCellsScrollViewReaderView
                Spacer()
                Divider()
                textFieldQuestionView
            }
            .padding()
            .onAppear {
                viewModel.loadHistory()
            }
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
    }

    private func chatCellsScrollView(proxy: ScrollViewProxy) -> some View {
        ScrollView {
            chatCellsView
            Text("")
                .id(bottomID)
        }
        .onChange(of: viewModel.scrollToBottom) { shouldScroll in
            if shouldScroll {
                withAnimation {
                    proxy.scrollTo(bottomID, anchor: .bottom)
                }
                viewModel.scrollToBottom = false
            }
        }
    }

    private var textFieldQuestionView: some View {
        HStack {
            TextField("", text: $viewModel.latestQuestion)
                .textFieldStyle(.roundedBorder)
                .disabled(viewModel.questionInProgress)
                .layoutPriority(2.0)
            SwiftUIButton(.compact,
                          viewModel: viewModel.sendButtonViewModel)
            .disabled(viewModel.questionInProgress || viewModel.latestQuestion.isEmpty)
            .layoutPriority(1.0)
            .frame(minWidth: 100)
        }
    }
}
